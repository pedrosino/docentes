class EditaisController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_edital?) }

  respond_to :docx

  def index
    @editais = Edital.all
  end

  def new
    @edital = Edital.new
  end

  def create
    @edital = Edital.new(edital_params)
    if @edital.save
      flash[:success] = "Criado com successo."
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = "Falha no cadastro."
      render :new
    end
  end

  def edit
    @edital = Edital.find(params[:id])
  end

  def update
    @edital = Edital.find(params[:id])
    if @edital.update_attributes(edital_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = "Falha ao salvar."
      render :edit
    end
  end

  def destroy
    @edital = Edital.find(params[:id])
    if @edital.destroy
      flash[:success] = "Edital excluído."
      redirect_to editais_path
    else
      flash[:warning] = "Falha na exclusão."
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
        doc.replace("$numero$", @edital.numero)
        doc.replace("$data$", @edital.data)
        doc.replace("$tipo$", @edital.tipo)

        # Write the document back to a temporary file
        tmp_file = Tempfile.new('word_tempate', "#{Rails.root}/tmp")
        doc.commit(tmp_file.path)

        # Respond to the request by sending the temp file
        send_file tmp_file.path, filename: "edital_#{@edital.id}_report.docx", disposition: 'attachment'
      end
    end
  end

  def edital_params
    edital_params = params.require(:edital).permit(:numero, :tipo, :data, :comeca_inscricao, :termina_inscricao)
  end
end
