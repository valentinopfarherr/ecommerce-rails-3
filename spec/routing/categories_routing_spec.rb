require 'rails_helper'

RSpec.describe 'Category routes', type: :routing do
  it 'routes GET /categories to categories#index' do
    expect(get: '/categories').to route_to('categories#index')
  end

  it 'routes GET /categories/new to categories#new' do
    expect(get: '/categories/new').to route_to('categories#new')
  end

  it 'routes POST /categories to categories#create' do
    expect(post: '/categories').to route_to('categories#create')
  end

  it 'routes GET /categories/:id to categories#show' do
    expect(get: '/categories/1').to route_to('categories#show', id: '1')
  end

  it 'routes GET /categories/:id/edit to categories#edit' do
    expect(get: '/categories/1/edit').to route_to('categories#edit', id: '1')
  end

  it 'routes PUT /categories/:id to categories#update' do
    expect(put: '/categories/1').to route_to('categories#update', id: '1')
  end

  it 'routes DELETE /categories/:id to categories#destroy' do
    expect(delete: '/categories/1').to route_to('categories#destroy', id: '1')
  end

  it 'routes GET /categories/:id/history to categories#history' do
    expect(get: '/categories/1/history').to route_to(
      controller: 'categories',
      action: 'history',
      id: '1'
    )
  end

  it 'routes history category_path helper to categories#history' do
    expect(get: history_category_path(1)).to route_to(
      controller: 'categories',
      action: 'history',
      id: '1'
    )
  end
end
