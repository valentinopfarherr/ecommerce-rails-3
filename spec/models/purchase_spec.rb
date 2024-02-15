require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:customer).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:product_id) }
  end

  describe 'callbacks' do
    it 'calculates total price before save' do
      product = FactoryBot.create(:product, price: 10.0)
      purchase = FactoryBot.build(:purchase, product: product, quantity: 3)

      expect(purchase.total_price).to be_nil

      purchase.save

      expect(purchase.total_price).to eq(30.0)
    end
  end
end
