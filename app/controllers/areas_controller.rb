class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_area?) }
  before_action -> { redireciona_usuario(:pode_criar_edital?) }, only: [:vaga]

  include ApplicationHelper

  def autocomplete_titulo_unidade_medida
    # Emulating 'full: true' and 'limit: 10' options from the gem
    render json: (Area::UNIDADES.grep(/#{params[:term]}/) | Titulo.select('distinct unidade_medida').where('LOWER(unidade_medida) like LOWER(?)', "%#{params[:term]}%").map(&:unidade_medida)).sort[0..9]
  end

  def index
    if current_user.pode_criar_edital?
      @areas = Area.all
    else
      @areas = Area.where(unidade_id: current_user.unidade_id)
    end

    if params[:search].present?
      @areas = @areas.select { |area| area.contem?(params[:search]) }
    end

    respond_to do |format|
      format.html {}
      format.js do
        render 'index'
      end
    end
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(area_params)

    if @area.save
      flash[:success] = 'Criado com sucesso.'
      redirect_to edit_area_path(@area)
    else
      flash[:danger] = 'Falha no cadastro.'
      render :new
    end
  end

  def edit
    params[:secao] ||= 'inicial'
    @area = Area.find(params[:id])
  end

  def vaga
    @area = Area.find(params[:id])
    tipos = vagas_efetivo if @area.tipo == 'concurso'
    tipos = vagas_substituto if @area.tipo == 'processo'
    @vagas = Vaga.where(tipo: tipos).sort_by { |vaga| vaga.nome.similar(@area.nome_vaga) }.reverse
  end

  def update
    @area = Area.find(params[:id])
    # Direciona para a próxima etapa quando salvar
    if @area.update_attributes(area_params)
      if params[:commit] == 'Confirm'
        flash[:success] = 'Solicitação enviada!'
        redirect_to areas_path
      elsif params[:commit] == 'vaga'
        flash[:success] = 'Vaga salva!'
        redirect_to areas_path
      else
        flash[:success] = 'Dados salvos!'
        redirect_to edit_area_path(@area, secao: area_params[:proximo])
      end
    else
      flash[:danger] = 'Falha ao salvar!'
      render :edit, secao: params[:secao]
    end
  end

  def destroy
    @area = Area.find(params[:id])
    if @area.destroy
      flash[:success] = 'Área excluída.'
      redirect_to areas_path
    else
      flash[:warning] = 'Falha na exclusão.'
      render :edit
    end
  end

  def area_params
    area_params = params.require(:area).permit(:unidade_id, :tipo_vaga, :nome_vaga, :nome, :subarea, :curso, :tipo,
      :campus, :graduacao, :descricao_graduacao, :especializacao, :descricao_especializacao, :mestrado, :descricao_mestrado,
      :doutorado, :descricao_doutorado, :disciplinas, :regime, :vagas, :prorrogar, :mantem_qualificacao, :qualif_prorrogar,
      :data_prova, :prova_didatica, :prova_procedimental, :responsavel, :situacao, :min_procedimental, :max_procedimental,
      :coautoria, :confirmada, :vaga_id,
      criterios_attributes: [:id, :nome, :descricao, :tipo_prova, :valor, :_destroy],
      titulos_attributes: [:id, :descricao, :valor, :maximo, :tipo, :unidade_medida, :prorrogacao, :_destroy])

    area_params[:confirmada] = true if params[:commit] == 'Confirm'

    # Se o usuário usou vírgula, temos que trocar por ponto decimal
    if area_params[:criterios_attributes]
      area_params[:criterios_attributes].each do |criterio|
        criterio[1][:valor] = criterio[1][:valor].sub(',', '.')
      end
    end

    if area_params[:titulos_attributes]
      area_params[:titulos_attributes].each do |titulo|
        titulo[1][:valor] = titulo[1][:valor].sub(',', '.')
        titulo[1][:maximo] = titulo[1][:maximo].sub(',', '.')
      end
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
