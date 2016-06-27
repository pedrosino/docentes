class Edital < ActiveRecord::Base
  has_many :areas

  validates :numero, uniqueness: true

  validate :numero_deve_ter_ano
  def numero_deve_ter_ano
    unless numero.include? '/20'
      errors.add(:numero, 'deve incluir o ano (p. ex. 2016)')
    end
  end

  validate :situacoes_possiveis
  def situacoes_possiveis
    if situacao && !SITUACOES.include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end

  validate :numero_processo
  def numero_processo
    if num_processo && num_processo.exclude?('23117')
      warnings.add(:num_processo, "é de outra Universidade?")
    end
  end

  SITUACOES = {
    'uni' => 'Unidade',
    'apr' => 'Aprovado',
    'pro' => 'Procuradoria',
    'pub' => 'Publicado',
    'enc' => 'Encerrado'
  }.freeze

  def titulacao
    areas.map(&:titulacao_minima).min
  end

  def unidades
    areas.map(&:unidade).map(&:sigla)
  end

  def contem?(busca)
    areas.map(&:nome).map(&:downcase).any? { |s| s.include?(busca.downcase) } || unidades.map(&:downcase).any? { |s| s.include?(busca.downcase) }
  end
end
