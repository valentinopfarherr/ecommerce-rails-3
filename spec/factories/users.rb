FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "buyer#{n}" }
    email { Faker::Internet.email }
    password { 'password' }
    role { 'buyer' }
  end
end
