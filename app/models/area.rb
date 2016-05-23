class Area < ActiveRecord::Base

  belongs_to :unidade
  belongs_to :edital

  validates :vagas, presence: true, on: :update

  validate :tipo_do_edital
  def tipo_do_edital
    if tipo && !['concurso','processo'].include?(tipo)
      errors.add(:tipo, "Inválido!")
    end
  end

  validate :regime_de_trabalho
  def regime_de_trabalho
    if regime && !['20','40','DE'].include?(regime)
      errors.add(:regime, "deve ser 20h, 40h ou 40h-DE")
    end
  end

  validate :concurso_tem_prova_didatica, on: :update
  def concurso_tem_prova_didatica
    if tipo == 'concurso' && !prova_didatica
      errors.add(:prova_didatica, "é obrigatória em concurso público")
    end
  end
end
