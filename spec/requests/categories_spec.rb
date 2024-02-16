require 'rails_helper'

RSpec.describe 'Categories Controller', type: :request do
  describe 'GET /categories' do
    context 'when the user is authenticated or not' do
      let(:user) { create(:user) }

      before do
        create_list(:category, 5)
        get '/categories', {}
        @json_response = JSON.parse(response.body)
      end

      it 'returns all categories' do
        expect(response).to have_http_status(:success)
        expect(@json_response.size).to eq(5)
      end
    end
  end

  describe 'GET /categories/:id' do
    let(:category) { create(:category) }

    context 'when the user is authenticated or not' do
      before do
        get "/categories/#{category.id}", {}
        @json_response = JSON.parse(response.body)
      end

      it 'returns the category' do
        expect(response).to have_http_status(:success)
        expect(@json_response['id']).to eq(category.id)
      end
    end
  end

  describe 'POST /categories' do
    let(:valid_attributes) { { name: 'demo' } }

    context 'when the user is authenticated is admin' do
      let(:admin) { create(:admin) }

      before do
        post '/categories', { category: valid_attributes }, auth_headers(admin)
        @json_response = JSON.parse(response.body)
      end

      it 'creates a new category' do
        expect(response).to have_http_status(:created)
        expect(@json_response['name']).to eq(valid_attributes[:name])
      end
    end

    context 'when the user is not authenticated' do
      let(:buyer) { create(:user) }

      before { post '/categories', { category: valid_attributes }, auth_headers(buyer) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not authenticated' do
      before { post '/categories', category: valid_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /categories/:id' do
    let!(:category) { create(:category) }
    let(:updated_attributes) { { name: 'Updated Category' } }

    context 'when the user is authenticated as admin' do
      let(:admin) { create(:admin) }

      before do
        put "/categories/#{category.id}", { category: updated_attributes }, auth_headers(admin)
        @json_response = JSON.parse(response.body)
      end

      it 'updates the category' do
        expect(response).to have_http_status(:success)
        expect(@json_response['name']).to eq(updated_attributes[:name])
      end
    end

    context 'when the user is authenticated as buyer' do
      let(:buyer) { create(:user) }

      before { put "/categories/#{category.id}", { category: updated_attributes }, auth_headers(buyer) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not authenticated' do
      before { put "/categories/#{category.id}", category: updated_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /categories/:id' do
    let!(:category) { create(:category) }

    context 'when the user is authenticated is admin' do
      let(:admin) { create(:admin) }

      before { delete "/categories/#{category.id}", {}, auth_headers(admin) }

      it 'deletes the category' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is authenticated is buyer' do
      let(:buyer) { create(:user) }

      before { delete "/categories/#{category.id}", {}, auth_headers(buyer) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not authenticated' do
      before { delete "/categories/#{category.id}" }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /categories/:id/history' do
    let(:admin_user) { create(:admin) }
    let(:regular_user) { create(:user) }
    let(:category) { Category.create(name: 'test') }

    it 'returns the history of the category' do
      category.update_attributes(name: 'Updated Name')

      get "/categories/#{category.id}/history", {}, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)
      history_response = JSON.parse(response.body)
      expect(history_response).to be_an(Array)
      expect(history_response.length).to eq(2)

      first_version = history_response.first
      expect(first_version['event']).to eq('update')
      expect(first_version['occurred_at']).to_not be_nil
      expect(first_version['category']['name']).to eq('test')
    end

    it 'returns unauthorized status for regular users' do
      get "/categories/#{category.id}/history", {}, auth_headers(regular_user)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized status without token' do
      get "/categories/#{category.id}/history"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
