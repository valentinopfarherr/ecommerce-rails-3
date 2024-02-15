require 'rails_helper'

RSpec.describe 'Admin routes', type: :routing do
  it 'routes GET /admins to admins#index' do
    expect(get: '/admins').to route_to('admins#index')
  end

  it 'routes GET /admins/new to admins#new' do
    expect(get: '/admins/new').to route_to('admins#new')
  end

  it 'routes POST /admins to admins#create' do
    expect(post: '/admins').to route_to('admins#create')
  end

  it 'routes GET /admins/:id to admins#show' do
    expect(get: '/admins/1').to route_to('admins#show', id: '1')
  end

  it 'routes GET /admins/:id/edit to admins#edit' do
    expect(get: '/admins/1/edit').to route_to('admins#edit', id: '1')
  end

  it 'routes PUT /admins/:id to admins#update' do
    expect(put: '/admins/1').to route_to('admins#update', id: '1')
  end

  it 'routes DELETE /admins/:id to admins#destroy' do
    expect(delete: '/admins/1').to route_to('admins#destroy', id: '1')
  end
end
