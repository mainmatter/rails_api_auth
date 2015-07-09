FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }

    trait :logged_in do
      association :login
    end
  end
end
