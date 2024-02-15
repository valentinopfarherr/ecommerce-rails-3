FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price }
    creator_id { User.where(role: 'admin').pluck(:id).sample }

    after(:create) do |product|
      categories = Category.all.sample(rand(1..3))
      product.categories << categories
    end

    transient do
      image_count { 3 }
    end

    after(:create) do |product, evaluator|
      evaluator.image_count.times do
        product.images.create(url: Faker::Internet.url)
      end
    end
  end
end
