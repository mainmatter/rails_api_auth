FactoryGirl.define do
  factory :login do
    identification { Faker::Internet.email }
    password       { Faker::Lorem.word }

    trait :facebook do
      uid { Faker::Number.number }
      password nil
      provider 'facebook'
    end
  end
end
