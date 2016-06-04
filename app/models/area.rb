class Area < ActiveRecord::Base

  belongs_to :unidade
  belongs_to :edital

  has_many :criterios
  has_many :titulos

  attr_accessor :proximo

  accepts_nested_attributes_for :criterios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :titulos, reject_if: :all_blank, allow_destroy: true

  # Reserva de vagas automática
  before_update do
    # Reserva para negros: 20% das vagas, arredondamento comum
    # 0,1 até 0,4 => arredonda para baixo
    # 0,5 até 0,9 => arredonda para cima
    # 3 vagas * 20% = 0,6 => arredonda para 1 vaga
    #
    # Reserva para pessoas com deficiência: 10%, arredondamento sempre para cima
    # limitado a 20%
    # Exemplo: 1 vaga * 10% = 0,1 => arredonda para 1
    # mas 1/1 = 100% => acima do teto de 20% => não tem reserva
    # 5 vagas * 10% = 0,5 => arredonda para 1
    # 1/5 = 20% => dentro do teto => reserva de uma vaga
    self.vagas_negros = (self.vagas * 0.2).round
    self.vagas_pcd = (self.vagas * 0.1).ceil
    if (self.vagas_pcd / self.vagas.to_f) > 0.2
      self.vagas_pcd -= 1
    end
  end

  validates :vagas, presence: true, on: :update
  validates :nome, presence: true, on: :update
  validates :qualificacao, presence: true, on: :update

  validate :tipo_do_edital
  def tipo_do_edital
    if tipo && !['concurso','processo'].include?(tipo)
      errors.add(:tipo, "Inválido!")
    end
  end

  validate :campus_validos
  def campus_validos
    if campus && !['Educação Física','Monte Carmelo','Patos de Minas','Santa Mônica','Umuarama'].include?(campus)
      errors.add(:campus, "inválido!")
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
end
