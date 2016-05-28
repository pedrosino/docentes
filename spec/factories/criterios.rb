FactoryGirl.define do
  factory :criterio do
    nome { Faker::Name.name }
    descricao { Faker::Lorem.paragraph }
    valor { Faker::Number.between(10,50) }

    trait :escrita do
      after (:create) do |criterio|
        criterio.tipo_prova = 'escrita'
      end
    end
  end
end
