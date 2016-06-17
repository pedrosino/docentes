FactoryGirl.define do
  factory :vaga do
    codigo { Faker::Number.number(7) }
    tipo { (vagas_efetivo + vagas_substituto).sample }
    nome { Faker::Name.name }
    data_inicio { Date.today }
    situacao { Vaga::SITUACOES.keys.sample }
  end

  trait :efetivo do
    tipo { vagas_efetivo.sample }
  end

  trait :substituto do
    tipo { vagas_substituto.sample }
  end
end
