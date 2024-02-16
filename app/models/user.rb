# User class represents a user in the system.
class User < ActiveRecord::Base
  include SCrypt

  attr_accessible :email, :role, :password
  attr_accessor :password

  has_many :purchases, foreign_key: 'customer_id'

  EMAIL_FORMAT_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_FORMAT_REGEX }
  validates :password, presence: true, length: { minimum: 8 }
  validates :role, presence: true, inclusion: { in: %w(admin buyer) }

  before_save :encrypt_password

  def admin?
    role == 'admin'
  end

  def authenticate(password)
    SCrypt::Password.new(password_digest) == password
  end

  def generate_jwt
    payload = { user_id: id, exp: 2.hours.from_now.to_i }
    JWT.encode(payload, secret_token)
  end

  def self.from_jwt(token)
    payload = JWT.decode(token, secret_token).first
    find(payload['user_id'])
  end

  def as_json(_options = {})
    {
      id: id,
      email: email,
      role: role
    }
  end

  private

  def encrypt_password
    self.password_digest = SCrypt::Password.create(password)
  end

  def secret_token
    Ecommerce::Application.config.secret_token
  end
end
