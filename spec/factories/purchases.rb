FactoryBot.define do
  factory :purchase do
    association :product, factory: :product
    association :customer, factory: :buyer
    purchase_date { Faker::Time.backward(365) }
    quantity { rand(1..5) }
  end
end
