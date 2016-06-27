class EditaisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :baixar_pdf]
  before_action -> { redireciona_usuario(:pode_criar_edital?) }, except: [:index, :show, :baixar_pdf]

  include ApplicationHelper
  include ActionView::Helpers::UrlHelper

  respond_to :docx

  def index
    @editais = Edital.all.sort_by(&:numero)
    @admin = current_user && current_user.pode_criar_edital?

    if params[:search].present?
      @editais = @editais.select { |edital| edital.contem?(params[:search]) }
    end

    unless @admin
      @editais = @editais.select { |edital| !edital.publicacao.nil? }
      @editais.sort_by(&:publicacao)
    end

    respond_to do |format|
      format.html {}
      format.js do
        render 'index'
      end
    end
  end

  def new
    @edital = Edital.new
  end

  def create
    @edital = Edital.new(edital_params)
    if @edital.save
      flash[:success] = 'Criado com successo.'
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = 'Falha no cadastro.'
      render :new
    end
  end

  def edit
    @edital = Edital.find(params[:id])
    @areas = Area.where('(edital_id is null or edital_id = ?) and tipo = ? and confirmada = ?', @edital.id, @edital.tipo, true).sort_by { |area| area[:unidade_id] }
  end

  def update
    @edital = Edital.find(params[:id])
    # Associa as áreas selecionadas ao edital
    areas = params[:areas]
    if areas
      areas.each do |area|
        Area.find(area).update!(edital_id: @edital.id)
      end
    end

    # Remove as áreas que foram desmarcadas
    difference = @edital.areas.pluck(:id) - (params[:areas] ? params[:areas].map(&:to_i) : [])
    Area.where(id: difference).update_all(edital_id: nil)

    if @edital.update_attributes(edital_params)
      flash[:success] = 'Salvo com sucesso!'
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = 'Falha ao salvar.'
      render :edit
    end
  end

  def show
    @edital = Edital.find(params[:id])
  end

  def publicar
    @edital = Edital.find(params[:id])

    tipo = tipo_certame[@edital.tipo]
    unidade = @edital.areas.first.unidade.nome
    link = raw link_to('Edital ' + @edital.numero, edital_path(@edital))
    titulo = "#{tipo} para docente n#{unidade.start_with?('F') ? 'a' : 'o'} #{unidade}"
    corpo = "#{"Área".pluralize(@edital.areas.length)}: #{@edital.areas.map(&:nome).to_sentence}<br />"
    corpo += "Veja mais informações: #{raw link}"

    if @edital.publicacao.present?
      flash[:warning] = "Edital já foi publicado!"
      redirect_to editais_path
    else
      post_redireciona(titulo: titulo, corpo: corpo.html_safe, data: Time.now)
    end

    # Atualiza o edital
    @edital.publicacao = Date.today
    @edital.situacao = 'pub'
    @edital.save

    render pdf: "Edital_PROGEP_#{@edital.numero}",
           template: 'editais/pdf.html.erb',
           save_to_file: "#{Rails.root}/public/editais/Edital_PROGEP_#{@edital.numero.sub('/', '_')}.pdf",
           save_only: true,
           page_size: 'A4',
           layout: 'pdf',
           margin: { top: 35, bottom: 12, left: 30, right: 10 },
           print_media_type: true,
           show_as_html: params.key?('debug'),
           header: { html: { template: 'editais/pdf_header.pdf.erb' } },
           footer: { right: '[page] de [topage]' }
  end

  def post_redireciona(post_atrs)
    @post = Post.new(post_atrs)
    if @post.save
      flash[:success] = 'Edital publicado!'
      redirect_to posts_path
    else
      flash[:danger] = "Falha na publicação"
      render :edit
    end
  end

  def baixar_pdf
    @edital = Edital.find(params[:id])
    send_file(
      "#{Rails.root}/public/editais/Edital_PROGEP_#{@edital.numero.sub('/', '_')}.pdf",
      type: 'application/pdf'
    )
  end

  def destroy
    @edital = Edital.find(params[:id])
    if @edital.destroy
      flash[:success] = 'Edital excluído.'
      redirect_to editais_path
    else
      flash[:warning] = 'Falha na exclusão.'
      render :edit
    end
  end

  def word
    @edital = Edital.find(params[:id])
    # respond_to do |format|
    #   format.docx do
    #     render docx: 'edital_word', filename: 'Edital.docx'
    #   end
    # end

    respond_to do |format|
      format.docx do
        doc = DocxReplace::Doc.new("#{Rails.root}/lib/docx_templates/my_template.docx", "#{Rails.root}/tmp")

        # Replace
        doc.replace('$numero$', @edital.numero)
        doc.replace('$data$', @edital.data)
        doc.replace('$tipo$', @edital.tipo == 'concurso' ? 'CONCURSO PÚBLICO' : 'PROCESSO SELETIVO SIMPLIFICADO')
        doc.replace('$area$', @edital.areas.first.nome)
        doc.replace('$vagas$', @edital.areas.first.vagas)
        doc.replace('$qualificacao$', @edital.areas.first.qualificacao)
        doc.replace('$regime$', @edital.areas.first.regime)

        # Write the document back to a temporary file
        tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp")
        doc.commit(tmp_file.path)

        # Respond to the request by sending the temp file
        send_file tmp_file.path, filename: "edital_#{@edital.id}_report.docx", disposition: 'attachment'
      end
    end
  end

  def pdf
    @edital = Edital.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Edital PROGEP #{@edital.numero}",
               template: 'editais/pdf.html.erb',
               disposition: 'inline',
               page_size: 'A4',
               layout: 'pdf',
               margin: { top: 35, bottom: 12, left: 30, right: 10 },
               print_media_type: true,
               show_as_html: params.key?('debug'),
               header: { html: { template: 'editais/pdf_header.pdf.erb' } },
               footer: { right: '[page] de [topage]' }
      end
    end
  end

  def edital_params
    edital_params = params.require(:edital).permit(:numero, :tipo, :data, :comeca_inscricao, :termina_inscricao, :publicacao)
    # As inscrições terminam sempre às 23:59:59 do último dia.
    # O campo do formulário passa apenas a data, então incluímos o horário no final da string
    if edital_params[:termina_inscricao]
      edital_params[:termina_inscricao] += ' 23:59:59'
    end
    edital_params
  end
end
