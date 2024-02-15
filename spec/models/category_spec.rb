require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('Admin') }
    it { should have_many(:product_categories) }
    it { should have_many(:products).through(:product_categories) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:category) }

    it { should validate_uniqueness_of(:name) }
  end

  describe 'class methods' do
    describe '.seed_attributes' do
      it 'should have seed_attributes method' do
        expect(Category).to respond_to(:seed_attributes)
      end
    end
  end
end
