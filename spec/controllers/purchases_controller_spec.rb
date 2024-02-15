# require 'rails_helper'

# RSpec.describe PurchasesController, type: :controller do
#   let(:product) { create(:product) }
#   let(:purchase_params) { attributes_for(:purchase, product_id: product.id) }

#   let(:admin_attrs) { create(:admin, password: 'secret') }
#   let(:token) { JWT.encode({ admin_id: admin_attrs.id }) }
#   let(:headers) { { 'Authorization' => "Bearer #{token}" } }

#   describe 'GET #index' do
#     it 'returns a success response' do
#       get :index, headers: headers
#       expect(response).to have_http_status(:success)
#     end
#   end

# describe 'GET #show' do
#   let(:purchase) { create(:purchase) }

#   it 'returns a success response' do
#     get :show, params: { id: purchase.id }
#     expect(response).to have_http_status(:success)
#   end
# end

# describe 'POST #create' do
#   context 'when user is authenticated' do
#     before { sign_in user }

#     it 'creates a new purchase' do
#       expect {
#         post :create, params: { purchase: purchase_params }
#       }.to change(Purchase, :count).by(1)
#     end

#     it 'returns a created response' do
#       post :create, params: { purchase: purchase_params }
#       expect(response).to have_http_status(:created)
#     end
#   end

#   context 'when user is not authenticated' do
#     it 'returns an unauthorized response' do
#       post :create, params: { purchase: purchase_params }
#       expect(response).to have_http_status(:unauthorized)
#     end
#   end
# end

# describe 'DELETE #destroy' do
#   let!(:purchase) { create(:purchase) }

#   it 'destroys the requested purchase' do
#     expect {
#       delete :destroy, params: { id: purchase.id }
#     }.to change(Purchase, :count).by(-1)
#   end

#   it 'returns a success response' do
#     delete :destroy, params: { id: purchase.id }
#     expect(response).to have_http_status(:success)
#   end
# end
# end
