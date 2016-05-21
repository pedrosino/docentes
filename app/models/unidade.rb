class Unidade < ActiveRecord::Base

  has_many :areas

  validate :tamanho_da_sigla
  def tamanho_da_sigla
    if sigla.length > 5
      errors.add(:sigla, "deve ter no máximo 5 letras.")
    end
  end
end
