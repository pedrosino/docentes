FactoryGirl.define do
  factory :user do
    nome { Faker::Name.name }
    email { Faker::Internet.email }
    password "usuarioufu"
    password_confirmation { "usuarioufu" }

    factory :user_unidade do
      nome "Faculdade XY"
      email "facxy@ufu.br"
      tipo 'u'

      after(:create) do |usuario|
        unidade = FactoryGirl.create(:unidade, sigla: 'FACXY')
        usuario.unidade_id = unidade.id
      end
    end

    factory :user_progep do
      nome "PROGEP"
      email "progep@ufu.br"
      tipo 'p'
    end

    trait :com_unidade do
      transient do
        id_unidade 1
        sigla_unidade 'PEDRO'
      end

      unidade_id { id_unidade }
      email { "#{sigla_unidade.downcase}@ufu.br" }
      tipo 'u'
    end

  end
end
