require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should belong_to(:creator).class_name('Admin') }
    it { should have_many(:product_categories).dependent(:destroy) }
    it { should have_many(:categories).through(:product_categories) }
    it { should have_many(:images).dependent(:destroy) }
    it { should have_many(:purchases) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:images).allow_destroy(true) }
    it { should accept_nested_attributes_for(:product_categories) }
  end

  describe 'methods' do
    let(:admin) { create(:admin) }
    let(:product) { create(:product, creator: admin) }

    it 'sends first purchase email if needed' do
      expect(EmailService).to receive(:send_admin_first_purchase_email).once
      product.send_first_purchase_email_if_needed
    end
  end
end
