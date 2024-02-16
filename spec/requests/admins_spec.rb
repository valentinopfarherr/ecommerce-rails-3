require 'rails_helper'

RSpec.describe 'Admins Controller', type: :request do
  describe 'GET /admins' do
    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before do
        create_list(:admin, 5)
        get '/admins', {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns all admins' do
        expect(response).to have_http_status(:success)
        expect(@json_response.size).to eq(6)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user) }

      before { get '/admins', {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /admins/:id' do
    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }
      let(:admin) { create(:admin) }

      before do
        get "/admins/#{admin.id}", {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns the admin' do
        expect(response).to have_http_status(:success)
        expect(@json_response['id']).to eq(admin.id)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user) }
      let(:admin) { create(:admin) }

      before { get "/admins/#{admin.id}", {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /admins' do
    let(:valid_attributes) { attributes_for(:admin) }

    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before do
        post '/admins', { admin: valid_attributes }, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'creates a new admin' do
        expect(response).to have_http_status(:created)
        expect(@json_response['admin']['email']).to eq(valid_attributes[:email])
      end
    end

    context 'when the user is not authenticated or not an admin' do
      before { post '/admins', admin: valid_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /admins/:id' do
    let(:admin) { create(:admin) }
    let(:updated_attributes) { { password: 'newpassword' } }

    context 'when the admin is authenticated and updating their own profile' do
      before { put "/admins/#{admin.id}", { admin: updated_attributes }, auth_headers(admin) }

      it 'updates the user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      before { put "/admins/#{admin.id}", params: { admin: updated_attributes } }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /admins/:id' do
    let!(:admin) { create(:admin) }

    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before { delete "/admins/#{admin.id}", {}, auth_headers(admin_user) }

      it 'deletes the admin' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      before { delete "/admins/#{admin.id}" }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
