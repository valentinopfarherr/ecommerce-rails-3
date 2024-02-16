require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(%w(admin buyer)) }
  end

  describe 'associations' do
    it { should have_many(:purchases) }
  end

  describe '#admin?' do
    let(:admin_user) { create(:admin) }
    let(:buyer_user) { create(:user) }

    it 'returns true for admin user' do
      expect(admin_user.admin?).to be_truthy
    end

    it 'returns false for buyer user' do
      expect(buyer_user.admin?).to be_falsey
    end
  end
end
