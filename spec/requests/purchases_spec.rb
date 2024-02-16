require 'rails_helper'

RSpec.describe 'Purchases Controller', type: :request do
  describe 'GET /purchases' do
    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before do
        create_list(:purchase, 5)
        get '/purchases', {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns all purchases' do
        expect(response).to have_http_status(:success)
        expect(@json_response.size).to eq(5)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user) }

      before { get '/purchases', {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /purchases/:id' do
    let(:purchase) { create(:purchase) }

    context 'when the user is authenticated as admin' do
      let(:admin_user) { create(:admin) }

      before do
        get "/purchases/#{purchase.id}", {}, auth_headers(admin_user)
        @json_response = JSON.parse(response.body)
      end

      it 'returns the purchase' do
        expect(response).to have_http_status(:success)
        expect(@json_response['id']).to eq(purchase.id)
      end
    end

    context 'when the user is not authenticated or not an admin' do
      let(:regular_user) { create(:user) }

      before { get "/purchases/#{purchase.id}", {}, auth_headers(regular_user) }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /purchases' do
    let(:product) { Product.create(name: 'test', price: 10.0, description: 'demo') }
    let(:valid_attributes) { { product_id: product.id, quantity: 2 } }

    context 'when the user is authenticated but attributes are invalid' do
      let(:admin_user) { create(:admin) }

      before { post '/purchases', { purchase: { product_id: 9999, quantity: 2 } }, auth_headers(admin_user) }

      it 'creates a new purchase' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user is not authenticated' do
      before { post '/purchases', purchase: valid_attributes }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /purchases/:id' do
    let!(:purchase) { create(:purchase) }

    context 'when the admin is authenticated' do
      let(:admin_user) { create(:admin) }

      before { delete "/purchases/#{purchase.id}", {}, auth_headers(admin_user) }

      it 'deletes the purchase' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not authenticated' do
      before { delete "/purchases/#{purchase.id}" }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
