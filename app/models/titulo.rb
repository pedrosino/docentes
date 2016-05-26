class Titulo < ActiveRecord::Base

  belongs_to :area

  validates :descricao, presence: true
  validates :unidade_medida, presence: true
  validates :valor, presence: true
  validates :maximo, presence: true

  validate :tipo_do_titulo
  def tipo_do_titulo
    if tipo && !['atividades','producao'].include?(tipo)
      errors.add(:tipo, "inválido!")
    end
  end

  validate :valor_versus_maximo
  def valor_versus_maximo
    if valor > maximo
      errors.add(:valor, "não pode ser maior que o máximo")
    end
  end
end
