class VagasController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redireciona_usuario(:pode_criar_edital?) }

  include ApplicationHelper

  def index
    @vagas = Vaga.all
    @vagas_ocupadas, @vagas_abertas = @vagas.partition{ |vaga| vaga.situacao == 'o' }
  end

  def new
    @vaga = Vaga.new
  end

  def create
    @vaga = Vaga.new(vaga_params)
    if @vaga.save!
      flash[:success] = "Criada com successo."
      redirect_to edit_vaga_path(@vaga)
    else
      flash[:danger] = "Falha no cadastro."
      render :new
    end
  end

  def edit
    @vaga = Vaga.find(params[:id])
  end

  def update
    @vaga = Vaga.find(params[:id])
    if @vaga.update_attributes(vaga_params)
      flash[:success] = "Dados atualizados"
      redirect_to vagas_path
    else
      flash[:danger] = "Falha na atualização"
      render :edit
    end
  end

  def destroy
  end

  def vaga_params
    vaga_params = params.require(:vaga).permit(:tipo, :nome, :codigo, :unidade_id, :data_inicio, :data_fim, :situacao, :regime, :campus, :observacao)
  end
end
