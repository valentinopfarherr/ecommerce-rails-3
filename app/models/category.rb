# Category class represents a category in the system.
class Category < ActiveRecord::Base
  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories
  has_many :products, through: :product_categories

  attr_accessible :name, :creator_id

  has_paper_trail
end
