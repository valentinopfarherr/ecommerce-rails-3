# Buyer class represents a buyer in the system.
class Buyer < User
  has_many :purchases, foreign_key: 'customer_id'
end
