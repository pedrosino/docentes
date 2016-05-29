FactoryGirl.define do
  factory :area do
    nome { Faker::Lorem.sentence(2, true, 2) }
    campus { Faker::Name.name }
    qualificacao { Faker::Lorem.sentence }
    regime { ['20','40','DE'].sample }
    vagas { Faker::Number.between(1,5) }

    trait :concurso do
      tipo 'concurso'
    end

    trait :processo do
      tipo 'processo'
    end

    trait :prorrogada do
      prorrogar true
    end
  end

end
