class EditaisController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_edital?) }

  respond_to :docx

  def index
    @editais = Editai.all
  end

  def new
    @edital = Editai.new
  end

  def create
    @edital = Editai.new(edital_params)
    if @edital.save
      flash[:success] = "Criado com successo."
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = "Falha no cadastro."
      render :new
    end
  end

  def edit
    @edital = Editai.find(params[:id])
  end

  def update
    @edital = Editai.find(params[:id])
    if @edital.update_attributes(edital_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to edit_edital_path(@edital)
    else
      flash[:danger] = "Falha ao salvar."
      render :edit
    end
  end

  def word
    @edital = Editai.find(params[:id])
    respond_to do |format|
      format.docx do
        render docx: 'edital_word', filename: 'Edital.docx'
      end
    end
  end

  def edital_params
    edital_params = params.require(:edital).permit(:numero, :tipo, :data, :comeca_inscricao, :termina_inscricao)
  end
end
