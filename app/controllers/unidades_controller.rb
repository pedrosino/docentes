class UnidadesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_unidade?) }

  def index
    @unidades = Unidade.all
  end

  def new
    @unidade = Unidade.new
  end

  def create
    @unidade = Unidade.new(unidade_params)
    if @unidade.save
      flash[:success] = 'Criado com sucesso.'
      redirect_to edit_unidade_path(@unidade)
    else
      flash[:success] = 'Falha no cadastro.'
      render :new
    end
  end

  def edit
    @unidade = Unidade.find(params[:id])
  end

  def update
    @unidade = Unidade.find(params[:id])
    if @unidade.update_attributes(unidade_params)
      flash[:success] = 'Dados atualizados'
      redirect_to edit_unidade_path(@unidade)
    else
      flash[:danger] = 'Falha na atualização'
      render :edit
    end
  end

  def destroy
    @unidade = Unidade.find(params[:id])
    if @unidade.destroy
      flash[:success] = 'Unidade excluída.'
      redirect_to unidades_path
    else
      flash[:warning] = 'Falha na exclusão.'
      render :edit
    end
  end

  def unidade_params
    params.require(:unidade).permit(:sigla, :nome, :diretor, :email, :telefone)
  end
end
