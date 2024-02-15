require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it 'validates the format of url' do
      should allow_value('http://example.com/image.jpg').for(:url)
      should allow_value('https://example.com/image.png').for(:url)
      should allow_value('ftp://example.com/image.gif').for(:url)
      should_not allow_value('invalid_url').for(:url)
    end
  end
end
