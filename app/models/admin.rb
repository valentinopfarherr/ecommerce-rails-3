# Admin class represents a admin in the system.
class Admin < User
  has_many :created_products, class_name: 'Product', foreign_key: 'creator_id'
  has_many :created_categories, class_name: 'Category', foreign_key: 'creator_id'
end
