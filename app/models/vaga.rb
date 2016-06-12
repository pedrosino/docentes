class Vaga < ActiveRecord::Base

  validates :tipo, presence: true
  validates :nome, presence: true

  validate :situacoes_possiveis
  def situacoes_possiveis
    if !['a','o','r'].include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end
end
