require 'rails_helper'

RSpec.describe 'Buyers routes', type: :routing do
  it 'routes GET /buyers to buyers#index' do
    expect(get: '/buyers').to route_to('buyers#index')
  end

  it 'routes GET /buyers/new to buyers#new' do
    expect(get: '/buyers/new').to route_to('buyers#new')
  end

  it 'routes POST /buyers to buyers#create' do
    expect(post: '/buyers').to route_to('buyers#create')
  end

  it 'routes GET /buyers/:id to buyers#show' do
    expect(get: '/buyers/1').to route_to('buyers#show', id: '1')
  end

  it 'routes GET /buyers/:id/edit to buyers#edit' do
    expect(get: '/buyers/1/edit').to route_to('buyers#edit', id: '1')
  end

  it 'routes PUT /buyers/:id to buyers#update' do
    expect(put: '/buyers/1').to route_to('buyers#update', id: '1')
  end

  it 'routes DELETE /buyers/:id to buyers#destroy' do
    expect(delete: '/buyers/1').to route_to('buyers#destroy', id: '1')
  end
end
