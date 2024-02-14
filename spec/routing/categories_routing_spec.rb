require 'rails_helper'

RSpec.describe 'Categories routing', type: :routing do
  it 'routes to #history' do
    expect(get: '/categories/1/history').to route_to('categories#history', id: '1')
  end
end
