class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_area?) }

  def index
    if current_user.tipo == 'p'
      @areas = Area.all
    else
      @areas = Area.where(unidade_id: current_user.unidade_id)
    end
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      flash[:success] = "Criado com sucesso."
      redirect_to edit_area_path(@area)
    else
      flash[:danger] = "Falha na criação."
      render :new
    end
  end

  def edit
    @area = Area.find(params[:id])
  end

  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(area_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to edit_area_path(@area)
    else
      flash[:danger] = "Falha ao salvar."
      render :edit
    end
  end

  def area_params
    area_params = params.require(:area).permit(:unidade_id, :nome, :subarea, :tipo, :campus, :qualificacao, :regime, :vagas, :prorrogar, :qualif_prorrogar, :data_prova, :responsavel, :situacao)
  end
end
