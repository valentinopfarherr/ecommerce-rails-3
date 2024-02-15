# require 'rails_helper'

# RSpec.describe Api::V1::StatisticsController, type: :controller do

#   describe 'GET #most_purchased_by_category' do
#     it "returns http success when admin is authenticated" do
#       admin = create(:admin)
#       token = generate_jwt_token(admin.id)
#       get :most_purchased_by_category
#       request.headers['Authorization'] = "Bearer #{token}"

#       get :most_purchased_by_category
#       expect(response).to have_http_status(:success)
#     end

#     # it 'caches the most purchased by category data' do
#     #   # Test caching behavior here
#     # end
#   end

#   # describe 'GET #top_revenue_by_category' do
#   #   it 'returns http success' do
#   #     get :top_revenue_by_category
#   #     expect(response).to have_http_status(:success)
#   #   end

#   #   it 'caches the top revenue by category data' do
#   #     # Test caching behavior here
#   #   end
#   # end

#   # describe 'GET #purchases' do
#   #   context 'with valid parameters' do
#   #     it 'returns http success' do

#   #       get :purchases, params: { start_date: '2023-01-01', end_date: '2023-01-31' }
#   #       expect(response).to have_http_status(:success)
#   #     end
#   #   end

#   #   context 'with invalid parameters' do
#   #     it 'returns unprocessable entity status' do

#   #       get :purchases, params: { start_date: 'invalid_date' }
#   #       expect(response).to have_http_status(:unprocessable_entity)
#   #     end
#   #   end
#   # end

#   # describe 'GET #purchases_by_granularity' do
#   #   context 'with valid parameters and granularity' do
#   #     it 'returns http success' do
#   #       get :purchases_by_granularity, params: { granularity: 'day', start_date: '2023-01-01', end_date: '2023-01-31' }
#   #       expect(response).to have_http_status(:success)
#   #     end
#   #   end

#   #   context 'with invalid parameters or granularity' do
#   #     it 'returns unprocessable entity status' do
#   #       get :purchases_by_granularity, params: { granularity: 'invalid_granularity' }
#   #       expect(response).to have_http_status(:unprocessable_entity)
#   #     end
#   #   end
#   # end
# end
