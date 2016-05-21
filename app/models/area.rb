class Area < ActiveRecord::Base

  belongs_to :unidade

  validate :tipo_do_edital
  def tipo_do_edital
    if tipo && !['Concurso Público','Processo Seletivo Simplificado'].include?(tipo)
      errors.add(:tipo, "Inválido!")
    end
  end

  validate :regime_de_trabalho
  def regime_de_trabalho
    if regime && !['20','40','DE'].include?(regime)
      errors.add(:regime, "deve ser 20h, 40h ou 40h-DE")
    end
  end
end
