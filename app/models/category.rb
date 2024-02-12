# Category class represents a category in the system.
class Category < ActiveRecord::Base
  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories
  has_many :products, through: :product_categories

  validates :name, uniqueness: true

  has_paper_trail
end
