FactoryGirl.define do
  factory :post do
    titulo { Faker::Lorem.sentence }
    corpo { Faker::Lorem.paragraph }
    data { (-5..5).to_a.sample.days.from_now }
  end
end
