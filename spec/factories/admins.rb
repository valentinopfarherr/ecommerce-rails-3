FactoryBot.define do
  factory :admin do
    sequence(:username) { |n| "admin#{n}" }
    email { Faker::Internet.email }
    password { 'password' }
    role { 'admin' }

    trait :with_custom_email do
      email { 'custom_admin@example.com' }
    end
  end
end
