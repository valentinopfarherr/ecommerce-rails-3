# Purchase class represents a purhcase in the system.
class Purchase < ActiveRecord::Base
  attr_accessible :quantity, :product_id, :purchase_date

  belongs_to :product
  belongs_to :customer, class_name: 'User'

  validates :quantity, :product_id, presence: true

  before_save :calculate_total_price

  def self.seed_attributes
    attr_accessible :customer_id
  end

  private

  def calculate_total_price
    self.total_price = (product.price * quantity).round(2) if product && quantity
  end
end
