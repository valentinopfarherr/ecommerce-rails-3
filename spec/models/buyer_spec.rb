require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe 'associations' do
    it { should have_many(:purchases) }
  end
end
