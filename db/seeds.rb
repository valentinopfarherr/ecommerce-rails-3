# db/seeds.rb

# Crear usuarios
admin_user = User.create(username: 'admin', email: 'admin@example.com', password: 'admin_password', role: 'admin')
customer_user1 = User.create(username: 'customer1', email: 'customer1@example.com', password: 'customer_password', role: 'customer')
customer_user2 = User.create(username: 'customer2', email: 'customer2@example.com', password: 'customer_password', role: 'customer')

# Crear categorías
electronics_category = Category.create(name: 'Electrónica', creator_id: admin_user.id)
clothing_category = Category.create(name: 'Ropa', creator_id: admin_user.id)

# Crear productos
phone_product = Product.create(name: 'Teléfono móvil', price: 500, creator_id: admin_user.id)
laptop_product = Product.create(name: 'Laptop', price: 1200, creator_id: admin_user.id)
shirt_product = Product.create(name: 'Camiseta', price: 20, creator_id: admin_user.id)
pants_product = Product.create(name: 'Pantalones', price: 30, creator_id: admin_user.id)

# Asociar productos a categorías
phone_product.categories << electronics_category
laptop_product.categories << electronics_category
shirt_product.categories << clothing_category
pants_product.categories << clothing_category

# Crear imágenes para productos
phone_image1 = Image.create(url: 'phone_image1.jpg', product_id: phone_product.id)
phone_image2 = Image.create(url: 'phone_image2.jpg', product_id: phone_product.id)
laptop_image = Image.create(url: 'laptop_image.jpg', product_id: laptop_product.id)
shirt_image = Image.create(url: 'shirt_image.jpg', product_id: shirt_product.id)
pants_image = Image.create(url: 'pants_image.jpg', product_id: pants_product.id)

# Crear compras
purchase1 = Purchase.create(product_id: phone_product.id, customer_id: customer_user1.id, quantity: 1)
purchase2 = Purchase.create(product_id: shirt_product.id, customer_id: customer_user2.id, quantity: 2)
purchase3 = Purchase.create(product_id: laptop_product.id, customer_id: customer_user1.id, quantity: 1)
purchase4 = Purchase.create(product_id: pants_product.id, customer_id: customer_user2.id, quantity: 3)

# Asegúrate de ejecutar "rake db:seed" para cargar estos datos en tu base de datos.
