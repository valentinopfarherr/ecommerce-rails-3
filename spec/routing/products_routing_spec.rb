require 'rails_helper'

RSpec.describe 'Products routing', type: :routing do
  it 'routes to #history' do
    expect(get: '/products/1/history').to route_to('products#history', id: '1')
  end
end
