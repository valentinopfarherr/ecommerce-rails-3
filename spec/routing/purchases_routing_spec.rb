require 'rails_helper'

RSpec.describe 'Purchases routes', type: :routing do
  it 'routes GET /purchases to purchases#index' do
    expect(get: '/purchases').to route_to('purchases#index')
  end

  it 'routes GET /purchases/new to purchases#new' do
    expect(get: '/purchases/new').to route_to('purchases#new')
  end

  it 'routes POST /purchases to purchases#create' do
    expect(post: '/purchases').to route_to('purchases#create')
  end

  it 'routes GET /purchases/:id to purchases#show' do
    expect(get: '/purchases/1').to route_to('purchases#show', id: '1')
  end

  it 'routes GET /purchases/:id/edit to purchases#edit' do
    expect(get: '/purchases/1/edit').to route_to('purchases#edit', id: '1')
  end

  it 'routes DELETE /purchases/:id to purchases#destroy' do
    expect(delete: '/purchases/1').to route_to('purchases#destroy', id: '1')
  end
end
