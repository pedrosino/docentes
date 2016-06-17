class Unidade < ActiveRecord::Base
  has_many :areas

  has_many :vagas

  validates :nome, presence: true, on: :update

  validate :tamanho_da_sigla
  def tamanho_da_sigla
    errors.add(:sigla, 'deve ter 5 letras.') if sigla.length != 5
  end
end
