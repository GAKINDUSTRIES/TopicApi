FactoryGirl.define do
  factory :topic do
    label { Faker::Book.title }
  end
end
