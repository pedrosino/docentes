FactoryGirl.define do
  factory :vaga do
    codigo { Faker::Number.number(7) }
    tipo { Faker::Name.name }
    nome { Faker::Name.name }
    data_inicio { Date.today }
  end

end
