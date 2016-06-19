class Area < ActiveRecord::Base
  belongs_to :unidade
  belongs_to :edital
  belongs_to :vaga

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
    if vagas
      self.vagas_negros = (vagas * 0.2).round
      self.vagas_pcd = (vagas * 0.1).ceil
      self.vagas_pcd -= 1 if (vagas_pcd / vagas.to_f) > 0.2
    end
  end

  validates :vagas, presence: true, if: -> { confirmada || proximo == 'escrita' }
  validates :nome, presence: true, if: -> { confirmada || proximo == 'escrita' }
  validates :tipo_vaga, presence: true, if: -> { confirmada || proximo == 'escrita' }
  validates :nome_vaga, presence: true, if: -> { confirmada || proximo == 'escrita' }

  validate :tipo_do_edital
  def tipo_do_edital
    if tipo && !['concurso', 'processo'].include?(tipo)
      errors.add(:tipo, "inválido!")
    end
  end

  validate :campus_validos
  def campus_validos
    if campus && !['Educação Física', 'Glória', 'Monte Carmelo', 'Patos de Minas', 'Santa Mônica', 'Umuarama'].include?(campus)
      errors.add(:campus, "inválido!")
    end
  end

  validate :regime_de_trabalho
  def regime_de_trabalho
    if regime
      if tipo == 'concurso' && ['20', '40', 'DE'].exclude?(regime)
        errors.add(:regime, 'deve ser 20h, 40h ou 40h-DE')
      elsif tipo == 'processo' && ['20', '40'].exclude?(regime)
        errors.add(:regime, 'deve ser 20h ou 40h (processo seletivo simplificado)')
      end
    end
  end

  validate :especificacao_qualificacao
  def especificacao_qualificacao
    if graduacao && descricao_graduacao == ''
      errors.add(:descricao_graduacao, 'deve ser preenchida')
    end

    if especializacao && descricao_especializacao == ''
      errors.add(:descricao_especializacao, 'deve ser preenchida')
    end

    if mestrado && descricao_mestrado == ''
      errors.add(:descricao_mestrado, 'deve ser preenchida')
    end

    if doutorado && descricao_doutorado == ''
      errors.add(:descricao_doutorado, 'deve ser preenchida')
    end
  end

  validate :concurso_tem_prova_didatica, if: -> { confirmada || proximo == 'titulos' }
  def concurso_tem_prova_didatica
    if tipo == 'concurso' && !prova_didatica
      errors.add(:prova_didatica, "é obrigatória em concurso público")
    end
  end

  validate :soma_prova_escrita, if: -> { confirmada || proximo == 'didatica' }
  def soma_prova_escrita
    criterios_escrita = criterios_da_prova('escrita')
    if criterios_escrita.length < 2
      errors.add(:base, "Você deve preencher pelo menos dois critérios da prova escrita.")
    end
    if criterios_escrita.length > 1
      soma = criterios_escrita.sum(&:valor)
      if soma != 100
        errors.add(:base, "A soma dos critérios da prova escrita não é igual 100 pontos.")
      end
    end
  end

  validate :soma_prova_didatica, if: -> { confirmada || proximo == 'titulos' }
  def soma_prova_didatica
    if prova_didatica
      criterios_didatica = criterios_da_prova('didatica')
      if criterios_didatica.length < 2
        errors.add(:base, "Você deve preencher pelo menos dois critérios da prova didática pedagógica.")
      end
      if criterios_didatica.length > 1
        soma = criterios_didatica.sum(&:valor)
        if soma != 100
          errors.add(:base, "A soma dos critérios da prova didática pedagógica não é igual 100 pontos.")
        end
      end
    end
  end

  validate :soma_prova_procedimental, if: -> { confirmada || proximo == 'titulos' }
  def soma_prova_procedimental
    if prova_procedimental
      criterios_procedimental = criterios_da_prova('procedimental')
      if criterios_procedimental.length < 2
        errors.add(:base, "Você deve preencher pelo menos dois critérios da prova didática procedimental.")
      end
      if criterios_procedimental.length > 1
        soma = criterios_procedimental.sum(&:valor)
        if soma != 100
          errors.add(:base, "A soma dos critérios da prova didática procedimental não é igual 100 pontos.")
        end
      end
    end
  end

  validate :duracao_prova_procedimental, if: -> { confirmada || proximo == 'titulos' }
  def duracao_prova_procedimental
    if prova_procedimental
      if min_procedimental && min_procedimental.exclude?('minuto') && min_procedimental.exclude?('hora')
        errors.add(:min_procedimental, "deve ser no formato '40 minutos' ou '1 hora e 10 minutos'")
      end
      if max_procedimental && max_procedimental.exclude?('minuto') && max_procedimental.exclude?('hora')
        errors.add(:max_procedimental, "deve ser no formato '40 minutos' ou '1 hora e 10 minutos'")
      end
    end
  end

  def maximo_atividades
    if tipo == 'processo' || (unidade && ['ESEBA', 'ESTES'].include?(unidade.sigla))
      45
    else
      20
    end
  end

  def maximo_producao
    if tipo == 'processo' || (unidade && ['ESEBA', 'ESTES'].include?(unidade.sigla))
      45
    else
      80
    end
  end

  validate :soma_titulos, if: -> { confirmada || proximo == 'inicial' }
  def soma_titulos
    atividades = titulos_do_tipo('atividades')
    if atividades.length < 2
      errors.add(:base, "Você deve preencher pelo menos dois itens de atividades didáticas e/ou profissionais.")
    end
    if atividades.length > 1
      soma = atividades.sum(&:maximo)
      if soma != maximo_atividades
        errors.add(:base, "A soma da pontuação das atividades didáticas e/ou profissionais não é igual ao valor máximo.")
      end
    end

    producao = titulos_do_tipo('producao').reject(&:prorrogacao)
    if producao.length < 2
      errors.add(:base, "Você deve preencher pelo menos dois itens de produção científica e/ou artística.")
    end
    if producao.length > 1
      soma = producao.sum(&:maximo)
      if soma != maximo_producao
        errors.add(:base, "A soma da pontuação da produção científica e/ou artística não é igual ao valor máximo.")
      end
    end

    if prorrogar && !mantem_qualificacao
      # Soma deve ser 70 pontos
      producao_pro = titulos_do_tipo('producao').select(&:prorrogacao)
      if producao_pro.length < 2
        errors.add(:base, "Você deve preencher pelo menos dois itens de produção científica e/ou artística.")
      end
      if producao_pro.length > 1
        soma = producao_pro.sum(&:maximo)
        if soma != 70
          errors.add(:base, "A soma da pontuação da produção científica e/ou artística não é igual ao valor máximo.")
        end
      end
    end
  end

  # 1 % 0.2 retorna 0.1999999999996
  # Não entendi bem por que...
  def modulo_especial(big, small)
    big - small * (big / small).floor
  end

  validate :proporcao_titulos
  def proporcao_titulos
    titulos.each do |titulo|
      if modulo_especial(titulo.maximo, titulo.valor) != 0
        errors.add(:base, "A proporção entre a pontuação individual e a pontuação máxima não está correta.")
      end
    end
  end

  def criterios_da_prova(prova)
    criterios.select { |c| c.tipo_prova == prova }.reject(&:_destroy)
  end

  def titulos_do_tipo(tipo)
    titulos.select { |t| t.tipo == tipo }.reject(&:_destroy)
  end

  def qualificacao
    q_array = []
    q_array << 'Graduação em ' + descricao_graduacao if graduacao
    q_array << 'Especialização em ' + descricao_especializacao if especializacao
    q_array << 'Mestrado em ' + descricao_mestrado if mestrado
    q_array << 'Doutorado em ' + descricao_doutorado if doutorado
    q_array.join(' com ')
  end

  def titulacao_minima
    if doutorado
      # Procura se tem prorrogação
      if prorrogar && !mantem_qualificacao
        return 3 if qualif_prorrogar.include? 'Mestrado'
        return 2 if qualif_prorrogar.include? "Especialização"
        return 0 if qualif_prorrogar.include? "Graduação"
      end
      return 4
    end

    if mestrado
      # Procura se tem prorrogação
      if prorrogar && !mantem_qualificacao
        return 2 if qualif_prorrogar.include? "Especialização"
        return 0 if qualif_prorrogar.include? "Graduação"
      end
      return 3
    end

    if especializacao
      return 0 if prorrogar && !mantem_qualificacao && qualif_prorrogar.include?("Graduação")
      return 2
    end

    return 0 if graduacao
  end
end
