# create the first admin if no admins exist
unless Admin.any?
  admin = Admin.new(
    username: 'admin',
    email: 'admin@example.com',
    password: 'password',
    role: 'admin'
  )
  if admin.save
    puts 'first admin created successfully!'
  else
    puts "error creating admin: #{admin.errors.full_messages.join(', ')}"
  end
else
  puts 'admin already exists!'
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
  Buyer.create(
    username: Faker::Lorem.word,
    email: Faker::Internet.email,
    password: 'password',
    role: 'buyer'
  )
end

# create categories
categories = ['Electronicos', 'Ropa', 'Hogar', 'Deportes', 'Juguetes']

categories.each do |category_name|
  unless Category.exists?(name: category_name)
    Category.create(
      name: category_name,
      creator_id: Admin.pluck(:id).sample
    )
  end
end

# create products
20.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price,
    creator_id: Admin.pluck(:id).sample
  )

  # create some images for each product
  3.times do
    product.images.create(
      url: "https://source.unsplash.com/featured/?product"
    )
  end

  # assign random categories to products
  rand(1..3).times do
    product.categories << Category.all.sample
  end
end

# create some purchases
50.times do
  Purchase.create(
    product: Product.all.sample,
    buyer: Buyer.all.sample,
    purchase_date: Faker::Time.backward(365)
  )
end
