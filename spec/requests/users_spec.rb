require 'rails_helper'

RSpec.describe 'Users Controller', type: :request do
  describe 'GET /users' do
    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before do
        create_list(:user, 5, role: 'buyer')
        get '/users', {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns all buyers' do
        expect(response).to have_http_status(:success)
        expect(@json_response.size).to eq(5)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user, role: 'buyer') }

      before { get '/users', {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }
      let(:user) { create(:user) }

      before do
        get "/users/#{user.id}", {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns the user' do
        expect(response).to have_http_status(:success)
        expect(@json_response['id']).to eq(user.id)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user) }

      before { get "/users/#{regular_user.id}", {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /users' do
    let(:valid_attributes) { attributes_for(:user) }

    context 'when the new user wants to create a user' do
      before do
        post '/users', user: valid_attributes
        @json_response = JSON.parse(response.body)
      end

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
        expect(@json_response['user']['email']).to eq(valid_attributes[:email])
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:user) { create(:user) }
    let(:updated_attributes) { { password: 'newpassword' } }

    context 'when the user is authenticated and updating their own profile' do
      let(:admin_user) { create(:admin) }
      before { put "/users/#{user.id}", { user: updated_attributes }, auth_headers(admin_user) }

      it 'updates the user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      before { put "/users/#{user.id}", user: updated_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { create(:user) }

    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before { delete "/users/#{user.id}", {}, auth_headers(admin_user) }

      it 'deletes the user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      before { delete "/users/#{user.id}" }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
