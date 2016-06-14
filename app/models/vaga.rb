class Vaga < ActiveRecord::Base

  belongs_to :unidade

  validates :tipo, presence: true
  validates :nome, presence: true
  validates :data_inicio, presence: true, on: :update

  validate :situacoes_possiveis
  def situacoes_possiveis
    if situacao && !SITUACOES.include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end

  validate :datas_inicio_e_fim
  def datas_inicio_e_fim
    if data_fim && data_inicio && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser maior que a data de início")
    end
  end

  SITUACOES = {
    "a" => "Aberta",
    "o" => "Ocupada",
    "r" => "Redistribuída",
    "s" => "Substituto",
    "c" => "Concurso",
    "n" => "Nomeação"
  }
end
