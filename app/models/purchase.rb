# Purchase class represents a purhcase in the system.
class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :buyer

  validates :product_id, presence: true
  validates :buyer_id, presence: true
end
