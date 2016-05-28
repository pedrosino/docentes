FactoryGirl.define do
  factory :area do
    nome { Faker::Lorem.sentence(2, true, 2) }
    tipo { ['concurso','processo'].sample }
    campus { Faker::Name.name }
    qualificacao { Faker::Lorem.sentence }
    regime { ['20','40','DE'].sample }
    vagas { Faker::Number.between(1,5) }

    trait :prorrogada do
      prorrogar true
    end
  end

end
