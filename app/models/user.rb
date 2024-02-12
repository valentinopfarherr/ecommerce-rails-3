# User class represents a user in the system.
class User < ActiveRecord::Base
  before_save :encrypt_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :role, presence: true, inclusion: { in: %w(admin buyer) }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def authenticate(password)
    Digest::SHA256.hexdigest(user.password) == password
  end

  def encrypt_password
    self.password = Digest::SHA256.hexdigest(password)
  end
end
