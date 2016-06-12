class Vaga < ActiveRecord::Base

  belongs_to :unidade

  validates :tipo, presence: true
  validates :nome, presence: true

  validate :situacoes_possiveis
  def situacoes_possiveis
    if !['a','o','r',nil].include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end
end
