require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'associations' do
    it { should have_many(:created_products).class_name('Product').with_foreign_key('creator_id') }
    it { should have_many(:created_categories).class_name('Category').with_foreign_key('creator_id') }
    it { should have_many(:purchases) }
  end
end
