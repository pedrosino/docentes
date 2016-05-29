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

  validate :concurso_tem_prova_didatica
  def concurso_tem_prova_didatica
    if tipo == 'concurso' && !prova_didatica && proximo == 'titulos'
      errors.add(:prova_didatica, "é obrigatória em concurso público")
    end
  end

  validate :soma_prova_escrita
  def soma_prova_escrita
    if proximo == 'didatica'
      if criterios_da_prova('escrita').length < 1
        errors.add(:base, "Você deve preencher os critérios da prova escrita.")
      end
      if criterios_da_prova('escrita').length > 0
        soma = criterios_da_prova('escrita').map(&:valor).reduce(&:+)
        if soma != 100
          errors.add(:base, "A soma dos critérios da prova escrita não atinge 100 pontos.")
        end
      end
    end
  end

  validate :soma_prova_didatica
  def soma_prova_didatica
    if proximo == 'titulos' && prova_didatica
      if criterios_da_prova('didatica').length < 1
        errors.add(:base, "Você deve preencher os critérios da prova didática pedagógica.")
      end
      if criterios_da_prova('didatica').length > 0
        soma = criterios_da_prova('didatica').map(&:valor).reduce(&:+)
        if soma != 100
          errors.add(:base, "A soma dos critérios da prova didática pedagógica não atinge 100 pontos.")
        end
      end
    end
  end

  validate :soma_prova_procedimental
  def soma_prova_procedimental
    if proximo == 'titulos' && prova_procedimental
      if criterios_da_prova('procedimental').length < 1
        errors.add(:base, "Você deve preencher os critérios da prova didática procedimental.")
      end
      if criterios_da_prova('procedimental').length > 0
        soma = criterios_da_prova('procedimental').map(&:valor).reduce(&:+)
        if soma != 100
          errors.add(:base, "A soma dos critérios da prova didática procedimental não atinge 100 pontos.")
        end
      end
    end
  end

  def criterios_da_prova(prova)
    criterios.select{ |c| c.tipo_prova == prova}
  end

  accepts_nested_attributes_for :criterios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :titulos, reject_if: :all_blank, allow_destroy: true
end
