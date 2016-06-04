class Unidade < ActiveRecord::Base

  has_many :areas

  validates :nome, presence: true

  validate :tamanho_da_sigla
  def tamanho_da_sigla
    if sigla.length != 5
      errors.add(:sigla, "deve ter 5 letras.")
    end
  end
end
