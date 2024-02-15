# create the first admin if no admins exist
unless Admin.any?
  admin = Admin.create(
    username: 'admin',
    email: 'admin@example.com',
    password: 'password',
    role: 'admin'
  )
end

# create admins
5.times do
  Admin.create(
    username: Faker::Lorem.word,
    email: Faker::Internet.email,
    password: 'password',
    role: 'admin'
  )
end

# create buyers
10.times do
  User.create(
    username: Faker::Lorem.word,
    email: Faker::Internet.email,
    password: 'password',
    role: 'buyer'
  )
end

# create categories
categories = ['Electronicos', 'Ropa', 'Hogar', 'Deportes', 'Juguetes']

Category.seed_attributes
admin_ids = User.where(role: 'admin').pluck(:id)

categories.each do |category_name|
  unless Category.exists?(name: category_name)
    Category.create(
      name: category_name,
      creator_id: admin_ids.sample
    )
  end
end

Product.seed_attributes

# create products
20.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price,
    creator_id: admin_ids.sample
  )

  3.times do |i|
    product.images.create!(
      url: Faker::Internet.url
    )
  end

  assigned_categories = []

  rand(1..3).times do
    category = Category.all.sample
    unless assigned_categories.include?(category)
      product.categories << category
      assigned_categories << category
    end
  end
end

# create some purchases

Purchase.seed_attributes
buyer_ids = User.where(role: 'buyer').pluck(:id)

50.times do
  Purchase.create!(
    product_id: Product.pluck(:id).sample,
    customer_id: buyer_ids.sample,
    purchase_date: Faker::Time.backward(365),
    quantity: rand(1..5)
  )
end

# create some purchases for the admin
5.times do
  Purchase.create!(
    product_id: Product.pluck(:id).sample,
    customer_id: admin_ids.sample,
    purchase_date: Faker::Time.backward(365),
    quantity: rand(1..5)
  )
end
