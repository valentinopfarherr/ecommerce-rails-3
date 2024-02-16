require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  it 'routes to sessions#create' do
    expect(post: '/sessions').to route_to('sessions#create')
  end
end
