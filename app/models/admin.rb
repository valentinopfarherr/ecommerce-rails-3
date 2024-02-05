# Admin class represents a admin in the system.
class Admin < ApplicationRecord
  has_one :user, as: :userable

  validates :full_name, presence: true
  validates :admin_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
