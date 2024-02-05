# Buyer class represents a buyer in the system.
class Buyer < ApplicationRecord
  has_one :user, as: :userable

  validates :full_name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
end
