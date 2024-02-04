class Product < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :categories
  has_many :images
  has_many :purchases
end
