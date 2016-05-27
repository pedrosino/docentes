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
    # No concurso público a prova didática (pedagógica) é obrigatória
    if @area.tipo == 'concurso'
      @area.prova_didatica = true
    end
    if @area.save
      flash[:success] = "Criado com sucesso."
      redirect_to edit_area_path(@area)
    else
      flash[:danger] = "Falha no cadastro."
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

  def destroy
    @area = Area.find(params[:id])
    if @area.destroy
      flash[:success] = "Área excluída."
      redirect_to areas_path
    else
      flash[:warning] = "Falha na exclusão."
      render :edit
    end
  end

  def area_params
    area_params = params.require(:area).permit(:unidade_id, :nome, :subarea, :tipo, :campus, :qualificacao, :disciplinas, :regime, :vagas, :prorrogar, :qualif_prorrogar, :data_prova, :prova_didatica, :prova_procedimental, :responsavel, :situacao,
      criterios_attributes: [:id, :nome, :descricao, :tipo_prova, :valor, :_destroy], titulos_attributes: [:id, :descricao, :valor, :maximo, :tipo, :unidade_medida, :_destroy])
  end
end
