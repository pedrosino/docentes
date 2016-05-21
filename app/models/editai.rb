class Editai < ActiveRecord::Base

  has_many :areas

  validates :numero, uniqueness: true

  validate :numero_deve_ter_ano
  def numero_deve_ter_ano
    unless numero.include? "/201"
      errors.add(:numero, "deve incluir o ano (p. ex. 2016)")
    end
  end
end
