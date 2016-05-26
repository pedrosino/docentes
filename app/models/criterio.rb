class Criterio < ActiveRecord::Base

  belongs_to :area

  validates :nome, presence: true
  validates :descricao, presence: true
  validates :valor, presence: true, numericality: { less_than_or_equal_to: 100 }

  validate :tipo_prova
  def tipo_prova
    if tipo_prova && !['escrita','didatica','procedimental'].include?(tipo_prova)
      errors.add(:tipo_prova, "inválido!")
    end
  end
end
