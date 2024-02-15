require 'rails_helper'

RSpec.describe 'Products routes', type: :routing do
  it 'routes GET /products to products#index' do
    expect(get: '/products').to route_to('products#index')
  end

  it 'routes GET /products/new to products#new' do
    expect(get: '/products/new').to route_to('products#new')
  end

  it 'routes POST /products to products#create' do
    expect(post: '/products').to route_to('products#create')
  end

  it 'routes GET /products/:id to products#show' do
    expect(get: '/products/1').to route_to('products#show', id: '1')
  end

  it 'routes GET /products/:id/edit to products#edit' do
    expect(get: '/products/1/edit').to route_to('products#edit', id: '1')
  end

  it 'routes PUT /products/:id to products#update' do
    expect(put: '/products/1').to route_to('products#update', id: '1')
  end

  it 'routes DELETE /products/:id to products#destroy' do
    expect(delete: '/products/1').to route_to('products#destroy', id: '1')
  end

  it 'routes to #history' do
    expect(get: '/products/1/history').to route_to('products#history', id: '1')
  end
end
