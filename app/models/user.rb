class User < ActiveRecord::Base
  has_many :purchases, foreign_key: 'customer_id'
  has_many :created_products, class_name: 'Product', foreign_key: 'creator_id'
  has_many :created_categories, class_name: 'Category', foreign_key: 'creator_id'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
