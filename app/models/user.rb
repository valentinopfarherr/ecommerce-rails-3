# User class represents a user in the system.
class User < ActiveRecord::Base
  belongs_to :userable, polymorphic: true

  has_many :purchases, foreign_key: 'customer_id'
  has_many :created_products, class_name: 'Product', foreign_key: 'creator_id'
  has_many :created_categories, class_name: 'Category', foreign_key: 'creator_id'
  attr_accessible :username, :email, :password, :password_confirmation

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
