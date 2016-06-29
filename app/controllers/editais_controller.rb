class EditaisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :baixar_pdf]
  before_action -> { redireciona_usuario(:pode_criar_edital?) }, except: [:index, :show, :baixar_pdf]

  include ApplicationHelper
  include ActionView::Helpers::UrlHelper

  respond_to :docx

  def index
    @editais = Edital.all.order(:numero)
    @admin = current_user && current_user.pode_criar_edital?

    if params[:search].present?
      @editais = @editais.select { |edital| edital.contem?(params[:search]) }
    end

    unless @admin
      @editais = @editais.select { |edital| !edital.publicacao.nil? }
      @editais.sort_by!(&:publicacao).reverse!
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

  def salvar_pdf(edital)
    pdf = render_to_string pdf: "Edital_PROGEP_#{edital.numero}",
                           template: 'editais/pdf.html.erb',
                           page_size: 'A4',
                           layout: 'pdf',
                           encoding: 'UTF-8',
                           margin: { top: 35, bottom: 12, left: 25, right: 10 },
                           print_media_type: true,
                           show_as_html: params.key?('debug'),
                           header: { html: { template: 'editais/pdf_header.pdf.erb' } },
                           footer: { right: '[page] de [topage]' }

    save_path = "#{Rails.root}/public/editais/Edital_PROGEP_#{edital.numero.sub('/', '_')}.pdf"
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
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
      salvar_pdf(@edital)
      post_redireciona(titulo: titulo, corpo: corpo.html_safe, data: Time.now)

      # Atualiza o edital
      @edital.publicacao = Date.today
      @edital.situacao = 'pub'
      @edital.save
    end
  end

  def post_redireciona(post_atrs)
    @post = Post.new(post_atrs)
    if @post.save
      flash[:success] = 'Edital publicado!'
    else
      flash[:danger] = "Falha na publicação"
    end
    redirect_to posts_path
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

    # render 'edital.rtf.rtf_rb'

    # styles                           = {}
    # styles['EMPHASISED']             = RTF::CharacterStyle.new
    # styles['EMPHASISED'].bold        = true
    # styles['EMPHASISED'].underline   = true
    # styles['NORMAL']                 = RTF::ParagraphStyle.new
    # styles['NORMAL'].space_after     = 300

    # document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Arial'))

    # document.paragraph(styles['NORMAL']) do |p|
    #    p << 'This document é a simple programmatically generated file that is '
    #    p << 'used to demonstração table generation. A table fônica containing 3 rows '
    #    p << 'anões three columns should be displayed below this text.'
    # end

    # table = document.table(3, 3, 2000, 4000, 2000)
    # table.border_width = 5
    # table[0][0] << 'Cell 0,0'
    # table[0][1].top_border_width = 10
    # table[0][1] << 'This is a little preamble text for '
    # table[0][1].apply(styles['EMPHASISED']) << 'Cell 0,1'
    # table[0][1].line_break
    # table[0][1] << ' to help in examining how formatting is working.'
    # table[0][2] << 'Cell 0,2'
    # table[1][0] << 'Cell 1,0'
    # table[1][1] << 'Cell 1,1'
    # table[1][2] << 'Cell 1,2'
    # table[2][0] << 'Cell 2,0'
    # table[2][1] << 'Cell 2,1'
    # table[2][2] << 'Cell 2,2'

    #################################################################
    document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))

    styles = {}
    styles['CS_CODE'] = RTF::CharacterStyle.new

    styles['CS_CODE'].font_size = 16

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "##ATO EXTRATO DO EDITAL DE ABERTURA DE #{tipo_certame[@edital.tipo].mb_chars.upcase} Nº #{@edital.numero}"
        n2.line_break
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "##TEX A Pró-Reitora de Gestão de Pessoas da Universidade Federal de Uberlândia, no uso de suas atribuições e considerando a delegação de competência que lhe foi outorgada por meio da Portaria/R/UFU/nº. 1.224, de 29/12/2015, do Reitor da Universidade Federal de Uberlândia, publicada no Diário Oficial da União em 11/01/2016; e tendo em vista o que estabelecem a Lei nº. 8.112, de 11/12/1990, a Lei 12.772 de 28/12/2012, a Lei 12.863 publicada no D.O.U. em 25/09/2013, bem como o Decreto 6.944 de 21/08/2009 publicado no D.O.U em 24/08/2009, o Decreto nº. 7.485 de 18/05/2011; alterado pelo Decreto nº. 8.259 de 29/05/2014 e a Portaria Interministerial MPOG/MEC nº. 111, de 03/04/2014; e também o Estatuto e o Regimento Geral da UFU, a Resolução nº 03/2015 do Conselho Diretor e demais legislações pertinentes, torna público que será realizado Concurso Público de Provas e Títulos, para o cargo de Professor da Carreira de Magistério Superior do Plano de Carreiras e Cargos de Magistério Federal da Universidade Federal de Uberlândia, mediante as normas contidas neste edital."
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "DA ESPECIFICAÇÃO DO #{tipo_certame[@edital.tipo].mb_chars.upcase}"
      end
    end

    #table = document.table(2, 4, 2177, 680, 3878, 1020)
    # Largura em twips => 15 twips = 1px
    # 1 cm = ~58 twips
    # http://www.unitconversion.org/typography/centimeters-to-twips-conversion.html
    linhas = @edital.areas.count
    table = document.table(linhas, 4, 1900, 681, 3203, 1020)
    table.border_width = 1
    table[0][0].apply(styles['CS_CODE']) << "Área"
    table[0][1].apply(styles['CS_CODE']) << "Nº de vagas"
    table[0][2].apply(styles['CS_CODE']) << "Qualificação Mínima Exigida"
    table[0][3].apply(styles['CS_CODE']) << "Regime de Trabalho"
    table[1][0].apply(styles['CS_CODE']) << @edital.areas.first.nome.to_s
    table[1][1].apply(styles['CS_CODE']) << @edital.areas.first.vagas.to_s
    table[1][2].apply(styles['CS_CODE']) << @edital.areas.first.qualificacao.to_s
    table[1][3].apply(styles['CS_CODE']) << @edital.areas.first.regime.to_s

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "REMUNERAÇÕES DO CARGO"
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "Composição: Vencimento Básico (VB) mais Retribuição por Titulação (RT) conforme tabela abaixo, nos termos do Anexo III da Lei 12.772/2012, e ainda o Auxílio Alimentação no valor de R$ 458,00."
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << 'tabela...'
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "DAS INSCRIÇÕES DOS CANDIDATOS"
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2 << "A inscrição do candidato implicará o conhecimento e a tácita aceitação das normas e condições estabelecidas neste Edital, em relação às quais não poderá alegar desconhecimento, e o comprovante de inscrição deverá ser mantido com o candidato, pois poderá lhe ser solicitado pela DIRETORIA DE PROCESSOS SELETIVOS - DIRPS."
      end
    end

    document.paragraph do |n1|
      n1.apply(styles['CS_CODE']) do |n2|
        n2.line_break
        n2 << "##ASS Marlene Marins de Camargos Borges"
      end
    end
    #################################################

    ################################################
    # document.paragraph do |p|
    #   p.apply(styles['CS_CODE']) do |pp|
    #     pp << "Olá tudo bem?"
    #   end
    # end

    # document.paragraph do |q|
    #   q.apply(styles['CS_CODE']) do |qq|
    #     qq.table(1, 2) do |tr|
    #       tr[0][0] << "oi"
    #       tr[0][1] << "dois"
    #     end
    #   end
    # end

    # document.paragraph do |r|
    #   r.apply(styles['CS_CODE']) do |rr|
    #     rr << "passou?"
    #   end
    # end

    # send_data document.to_rtf, filename: "Extrato Edital #{@edital.numero.sub('/', '-')}.rtf", type: 'text/richtext'
    send_data unicode_translate(document.to_rtf), filename: "Extrato Edital #{@edital.numero.sub('/', '-')}.rtf", type: 'text/richtext'

    # respond_to do |format|
    #   format.docx do
    #     render docx: 'edital_word', filename: 'Edital.docx'
    #   end
    # end

    # respond_to do |format|
    #   format.docx do
    #     doc = DocxReplace::Doc.new("#{Rails.root}/lib/docx_templates/my_template.docx", "#{Rails.root}/tmp")

    #     # Replace
    #     doc.replace('$numero$', @edital.numero)
    #     doc.replace('$data$', @edital.data)
    #     doc.replace('$tipo$', @edital.tipo == 'concurso' ? 'CONCURSO PÚBLICO' : 'PROCESSO SELETIVO SIMPLIFICADO')
    #     doc.replace('$area$', @edital.areas.first.nome)
    #     doc.replace('$vagas$', @edital.areas.first.vagas)
    #     doc.replace('$qualificacao$', @edital.areas.first.qualificacao)
    #     doc.replace('$regime$', @edital.areas.first.regime)

    #     # Write the document back to a temporary file
    #     tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp")
    #     doc.commit(tmp_file.path)

    #     # Respond to the request by sending the temp file
    #     send_file tmp_file.path, filename: "edital_#{@edital.id}_report.docx", disposition: 'attachment'
    #   end
    # end
  end

  def pdf
    @edital = Edital.find(params[:id])
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
