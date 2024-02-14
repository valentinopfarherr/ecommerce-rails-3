# Category class represents a category in the system.
class Category < ActiveRecord::Base
  has_paper_trail
  
  attr_accessible :name

  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories
  has_many :products, through: :product_categories

  validates :name, uniqueness: true

  def self.seed_attributes
    attr_accessible :creator_id
  end
end
