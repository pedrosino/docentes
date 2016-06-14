class Vaga < ActiveRecord::Base

  belongs_to :unidade

  validates :tipo, presence: true
  validates :nome, presence: true

  validate :situacoes_possiveis
  def situacoes_possiveis
    if !['a','o','r','s','c','n',nil].include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end

  validate :datas_inicio_e_fim
  def datas_inicio_e_fim
    if data_fim && data_inicio && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser maior que a data de início")
    end
  end
end
