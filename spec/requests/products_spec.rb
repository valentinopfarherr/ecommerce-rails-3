require 'rails_helper'

RSpec.describe 'Products Controller', type: :request do
  describe 'GET /products' do
    context 'when the user is authenticated or not' do
      let(:user) { create(:user) }

      before do
        create_list(:product, 5)
        get '/products', {}
        @json_response = JSON.parse(response.body)
      end

      it 'returns all products' do
        expect(response).to have_http_status(:success)
        expect(@json_response.size).to eq(5)
      end
    end
  end

  describe 'GET /products/:id' do
    let(:product) { create(:product) }

    context 'when the user is authenticated or not' do
      before do
        get "/products/#{product.id}", {}
        @json_response = JSON.parse(response.body)
      end

      it 'returns the product' do
        expect(response).to have_http_status(:success)
        expect(@json_response['id']).to eq(product.id)
      end
    end
  end

  describe 'POST /products' do
    let(:valid_attributes) { { name: 'Sample Product', description: 'demo', price: 20.00 } }

    context 'when the user is authenticated as admin' do
      let(:admin) { create(:admin) }

      before do
        post '/products', { product: valid_attributes }, auth_headers(admin)
        @json_response = JSON.parse(response.body)
      end

      it 'creates a new product' do
        expect(response).to have_http_status(:created)
        expect(@json_response['name']).to eq(valid_attributes[:name])
        expect(@json_response['description']).to eq(valid_attributes[:description])
        expect(@json_response['price']).to eq(valid_attributes[:price].to_s)
      end
    end

    context 'when the user is not authenticated' do
      let(:user) { create(:user) }

      before { post '/products', { product: valid_attributes }, auth_headers(user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /products/:id' do
    let!(:product) { create(:product) }
    let(:updated_attributes) { { name: 'Updated Product' } }

    context 'when the user is authenticated as admin' do
      let(:admin) { create(:admin) }

      before do
        put "/products/#{product.id}", { product: updated_attributes }, auth_headers(admin)
        @json_response = JSON.parse(response.body)
      end

      it 'updates the product' do
        expect(response).to have_http_status(:success)
        expect(@json_response['name']).to eq(updated_attributes[:name])
      end
    end

    context 'when the user is authenticated as buyer' do
      let(:buyer) { create(:user) }

      before { put "/products/#{product.id}", { product: updated_attributes }, auth_headers(buyer) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not authenticated' do
      before { put "/products/#{product.id}", product: updated_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /products/:id' do
    let!(:product) { create(:product) }

    context 'when the user is authenticated as admin' do
      let(:admin) { create(:admin) }

      before { delete "/products/#{product.id}", {}, auth_headers(admin) }

      it 'deletes the product' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is authenticated as buyer' do
      let(:buyer) { create(:user) }

      before { delete "/products/#{product.id}", {}, auth_headers(buyer) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not authenticated' do
      before { delete "/products/#{product.id}" }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /products/:id/history' do
    let(:admin_user) { create(:admin) }
    let(:regular_user) { create(:user) }
    let(:product) { Product.create(name: 'test', price: 10.0, description: 'demo') }

    it 'returns the history of the product' do
      product.update_attributes(name: 'Updated Name')

      get "/products/#{product.id}/history", {}, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)
      history_response = JSON.parse(response.body)
      expect(history_response).to be_an(Array)
      expect(history_response.length).to eq(2)

      first_version = history_response.first
      expect(first_version['event']).to eq('update')
      expect(first_version['occurred_at']).to_not be_nil
      expect(first_version['product']['name']).to eq('test')
      expect(first_version['product']['price']).to eq(10.0)
    end

    it 'returns unauthorized status for regular users' do
      get "/products/#{product.id}/history", {}, auth_headers(regular_user)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized status without token' do
      get "/products/#{product.id}/history"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
