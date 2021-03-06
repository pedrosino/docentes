FactoryGirl.define do
  factory :titulo do
    descricao { Faker::Lorem.paragraph }
    comprovacao { Faker::Lorem.paragraph }
    valor { Faker::Number.between(1, 10) }
    maximo { Faker::Number.between(10, 50) }
    unidade_medida { Area::UNIDADES.sample }

    trait :atividades do
      tipo 'atividades'
    end

    trait :producao do
      tipo 'producao'
    end
  end
end
