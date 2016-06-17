FactoryGirl.define do
  factory :area do
    nome { Faker::Lorem.sentence(2, true, 2) }
    campus { ['Educação Física', 'Glória', 'Monte Carmelo', 'Patos de Minas', 'Santa Mônica', 'Umuarama'].sample }
    qualificacao { Faker::Lorem.sentence }
    vagas { Faker::Number.between(1, 5) }

    trait :concurso do
      tipo 'concurso'
      regime { ['20', '40', 'DE'].sample }
    end

    trait :processo do
      tipo 'processo'
      regime { ['20', '40'].sample }
    end

    trait :prorrogada do
      prorrogar true
    end
  end
end
