require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:category) }
  end

  describe '#valid_category?' do
    it 'returns true if the associated category exists' do
      category = create(:category)
      product_category = create(:product_category, category: category)

      expect(product_category.valid_category?).to be true
    end

    it 'returns false if the associated category does not exist' do
      product_category = build(:product_category, category_id: 999)

      expect(product_category.valid_category?).to be false
    end
  end
end
