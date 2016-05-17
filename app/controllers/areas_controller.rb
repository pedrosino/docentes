class AreasController < ApplicationController
  before_action :authenticate_user!

  def index
    #@areas = Area.find_by_unidade(current_user.unidade)
    @areas = Area.all
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
  end

  def area_params
    area_params = params.require(:area).permit(:unidade, :nome, :subarea, :tipo, :campus, :qualificacao, :regime, :vagas, :prorrogar, :qualif_prorrogar, :data_prova)
  end
end
