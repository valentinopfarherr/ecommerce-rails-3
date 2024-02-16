require 'rails_helper'

RSpec.describe 'Sessions Controller', type: :request do
  describe 'POST /sessions' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    context 'when valid credentials are provided' do
      it 'returns a token and user data' do
        post '/sessions', email: 'test@example.com', password: 'password'
        @json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(@json_response['token']).to be_present
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns unauthorized status' do
        post '/sessions', email: 'test@example.com', password: 'wrong_password'
        @json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(@json_response['error']).to eq('invalid email or password')
      end
    end
  end
end
