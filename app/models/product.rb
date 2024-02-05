# Product class represents a product in the system.
class Product < ActiveRecord::Base
  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :images
  has_many :purchases

  attr_accessible :name, :description, :price, :creator_id

  has_paper_trail
end
