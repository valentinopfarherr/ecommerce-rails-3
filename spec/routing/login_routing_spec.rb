require 'rails_helper'

RSpec.describe 'Login Routing', type: :routing do
  it 'routes POST /login to auth#login' do
    expect(post: '/login').to route_to('auth#login')
  end
end
