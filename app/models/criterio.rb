class Criterio < ActiveRecord::Base

  belongs_to :area

  validates :nome, presence: true, on: :update
  validates :descricao, presence: true, on: :update
  validates :valor, presence: true, value:

  validate :tipo_prova
  def tipo_prova
    if tipo_prova && !['escrita','didatica','procedimental'].include?(tipo_prova)
      errors.add(:tipo_prova, "inválido!")
    end
  end
end
