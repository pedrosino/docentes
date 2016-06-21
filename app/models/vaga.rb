class Vaga < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :unidade

  has_one :area

  validates :tipo, presence: true
  validates :nome, presence: true
  validates :data_inicio, presence: true, on: :update

  validate :situacoes_possiveis
  def situacoes_possiveis
    if situacao && !SITUACOES.include?(situacao)
      errors.add(:situacao, "inválida")
    end
  end

  validate :datas_inicio_e_fim
  def datas_inicio_e_fim
    if data_fim && data_inicio && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser maior que a data de início")
    end
  end

  validate :vaga_substituto_situacoes
  def vaga_substituto_situacoes
    if vagas_substituto.include?(tipo) && ['o','r','n'].include?(situacao)
      errors.add(:situacao, "não pode ser 'ocupada' (vaga temporária)'")
    end
  end

  SITUACOES = {
    'a' => 'Aberta',
    'o' => 'Ocupada',
    'r' => 'Redistribuída',
    's' => 'Substituto',
    'c' => 'Concurso',
    'n' => 'Nomeação'
  }.freeze
end
