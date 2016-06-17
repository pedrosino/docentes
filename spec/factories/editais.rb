FactoryGirl.define do
  factory :edital do
    numero { Faker::Number.number(3).to_s << '/2016' }
    data { Faker::Date.forward(10) }
    comeca_inscricao { 10.days.from_now }
    termina_inscricao { 24.days.from_now }
  end
end
