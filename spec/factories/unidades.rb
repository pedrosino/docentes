FactoryGirl.define do
  factory :unidade do
    sigla { Faker::Lorem.characters(5) }
    nome { Faker::Company.name }
    diretor { Faker::Name.name }
    email { Faker::Internet.email }
    telefone { Faker::PhoneNumber.phone_number }
  end
end
