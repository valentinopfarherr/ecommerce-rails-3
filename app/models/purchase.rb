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

  def as_json(_options = {})
    {
      id: id,
      product: { id: product_id, name: product.name },
      quantity: quantity,
      total_price: total_price,
      customer_id: customer_id,
      purchase_date: purchase_date
    }
  end

  private

  def calculate_total_price
    self.total_price = (product.price * quantity).round(2) if product && quantity
  end
end
