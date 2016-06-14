FactoryGirl.define do
  factory :vaga do
    codigo { Faker::Number.number(7) }
    tipo { tipos_vaga.sample }
    nome { Faker::Name.name }
    data_inicio { Date.today }
    situacao { situacao_vaga.sample }
  end

  trait :efetivo do
    tipo { vagas_efetivo.sample }
  end

  trait :substituto do
    tipo { vagas_substituto.sample }
  end

  trait :com_tipo do
    transient do
      tipo_passado 'Aposentadoria'
    end

    tipo { tipo_passado }
  end

  trait :com_situacao do
    transient do
      situacao_passada 'Aberta'
    end

    situacao { situacao_passada }
  end

end
