# require 'rails_helper'

# RSpec.describe AuthController, type: :controller do
#   let(:admin) { FactoryBot.create(:admin, email: 'test@example.com', password: 'password123') }

#   describe 'POST #login' do
#     context 'with valid credentials' do
#       it 'returns a JWT token' do
#         post :login, params: { email: admin.email, password: 'password123' }
#         expect(response).to have_http_status(:success)
#         expect(JSON.parse(response.body)).to have_key('token')
#       end
#     end

#     context 'with invalid credentials' do
#       it 'returns unauthorized' do
#         post :login, params: { email: 'invalid@example.com', password: 'invalidpassword' }
#         expect(response).to have_http_status(:unauthorized)
#         expect(JSON.parse(response.body)).to have_key('error')
#       end
#     end
#   end
# end
