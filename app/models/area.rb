class Area < ActiveRecord::Base

  belongs_to :unidade
  belongs_to :edital

  has_many :criterios
  has_many :titulos

  attr_accessor :proximo

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
    if tipo == 'concurso' && !prova_didatica && proximo == 'titulos'
      errors.add(:prova_didatica, "é obrigatória em concurso público")
    end
  end

  validate :soma_prova_escrita
  def soma_prova_escrita
    if proximo == 'didatica' && criterios.select{ |c| c.tipo_prova == 'escrita' }.length < 1
      errors.add(:base, "Você deve preencher os critérios da prova escrita.")
    end
    if proximo == 'didatica' && criterios.select{ |c| c.tipo_prova == 'escrita' }.length > 0
      soma = 0
      criterios.select{ |c| c.tipo_prova == 'escrita' }.each do |criterio|
        soma += criterio.valor
      end
      if soma != 100
        errors.add(:base, "A soma dos critérios não atinge 100 pontos.")
      end
    end
  end

  validate :soma_prova_didatica
  def soma_prova_didatica
    if proximo == 'titulos' && prova_didatica && criterios.select{ |c| c.tipo_prova == 'didatica' }.length > 0
      soma = 0
      criterios.select{ |c| c.tipo_prova == 'didatica' }.each do |criterio|
        soma += criterio.valor
      end
      if soma != 100
        errors.add(:base, "A soma dos critérios da prova didática pedagógica não atinge 100 pontos.")
      end
    end
  end

  validate :soma_prova_procedimental
  def soma_prova_procedimental
    if proximo == 'titulos' && prova_procedimental && criterios.select{ |c| c.tipo_prova == 'procedimental' }.length > 0
      soma = 0
      criterios.select{ |c| c.tipo_prova == 'procedimental' }.each do |criterio|
        soma += criterio.valor
      end
      if soma != 100
        errors.add(:base, "A soma dos critérios da prova didática procedimental não atinge 100 pontos.")
      end
    end
  end

  accepts_nested_attributes_for :criterios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :titulos, reject_if: :all_blank, allow_destroy: true
end
