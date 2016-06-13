class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_area?) }

  def index
    if current_user.pode_criar_edital?
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
    params[:secao] ||= "inicial"
    @area = Area.find(params[:id])
  end

  # O formulário de edição da área é dividido em partes.
  # Cada parte tem uma ação para carregar a view, mas todas
  # chamam a ação 'update', que salva o que foi passado e
  # redireciona para a próxima etapa.
  def inicial
    @area = Area.find(params[:id])
  end

  def escrita
    @area = Area.find(params[:id])
  end

  def didatica
    @area = Area.find(params[:id])
  end

  def titulos
    @area = Area.find(params[:id])
  end

  def update
    @area = Area.find(params[:id])
    # Direciona para a próxima etapa quando salvar
    if @area.update_attributes(area_params)
      if params[:commit] == "Confirm"
        flash[:success] = "Solicitação enviada!"
        redirect_to areas_path
      else
        flash[:success] = "Dados salvos!"
        redirect_to edit_area_path(@area, secao: area_params[:proximo])
      end
    else
      flash[:danger] = "Falha ao salvar!"
      render :edit, secao: params[:secao]
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
    area_params = params.require(:area).permit(:unidade_id, :tipo_vaga, :nome_vaga, :nome, :subarea, :curso, :tipo, :campus, :qualificacao, :disciplinas, :regime, :vagas, :prorrogar, :qualif_prorrogar, :data_prova, :prova_didatica, :prova_procedimental, :responsavel, :situacao, :min_procedimental, :max_procedimental, :coautoria, :confirmada,
      criterios_attributes: [:id, :nome, :descricao, :tipo_prova, :valor, :_destroy], titulos_attributes: [:id, :descricao, :valor, :maximo, :tipo, :unidade_medida, :_destroy])
    if params[:commit] == "Confirm"
      area_params[:confirmada] = true
    end
    secao = params[:secao]
    case secao
    when 'inicial'
      area_params[:proximo] = 'escrita'
    when 'escrita'
      area_params[:proximo] = 'didatica'
    when 'didatica'
      area_params[:proximo] = 'titulos'
    when 'titulos'
      area_params[:proximo] = 'inicial'
    end
    area_params
  end
end
