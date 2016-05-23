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
