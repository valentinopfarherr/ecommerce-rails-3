# User class represents a user in the system.
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :username, :role, :email, :password, :password_confirmation, :remember_me

  EMAIL_FORMAT_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(admin buyer) }

  def admin?
    role == 'admin'
  end
end
