require 'rails_helper'

RSpec.describe 'users routes', type: :routing do
  it 'routes GET /users to users#index' do
    expect(get: '/users').to route_to('users#index')
  end

  it 'routes GET /users/new to users#new' do
    expect(get: '/users/new').to route_to('users#new')
  end

  it 'routes POST /users to users#create' do
    expect(post: '/users').to route_to('users#create')
  end

  it 'routes GET /users/:id to users#show' do
    expect(get: '/users/1').to route_to('users#show', id: '1')
  end

  it 'routes GET /users/:id/edit to users#edit' do
    expect(get: '/users/1/edit').to route_to('users#edit', id: '1')
  end

  it 'routes PUT /users/:id to users#update' do
    expect(put: '/users/1').to route_to('users#update', id: '1')
  end

  it 'routes DELETE /users/:id to users#destroy' do
    expect(delete: '/users/1').to route_to('users#destroy', id: '1')
  end
end
