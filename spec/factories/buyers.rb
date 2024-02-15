FactoryBot.define do
  factory :buyer, class: 'Buyer' do
    sequence(:username) { |n| "buyer#{n}" }
    email { Faker::Internet.email }
    password { 'password' }
    role { 'buyer' }
  end
end
