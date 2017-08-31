FactoryGirl.define do
  factory :target do
    user
    topic
    lat     { Faker::Number.decimal(2, 6) }
    lng     { Faker::Number.decimal(2, 6) }
    radius  { Faker::Number.number(7) }
  end
end
