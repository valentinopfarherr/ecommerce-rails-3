require 'rails_helper'

RSpec.describe 'StatisticsController', type: :request do
  describe 'GET /most_purchased_by_category' do
    let(:admin_user) { create(:admin) }

    it 'returns the most purchased categories' do
      get '/api/v1/statistics/most_purchased_by_category', {}, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      expect(json_response.keys).to all(be_a(String))

      expect(json_response.values).to all(be_a(Hash))
      expect(json_response.values).to all(include('id', 'name', 'total_purchases'))
    end

    it 'returns unauthorized when not authenticated' do
      get '/api/v1/statistics/most_purchased_by_category'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /top_revenue_by_category' do
    let(:admin_user) { create(:admin) }

    it 'returns the categories with top revenue' do
      get '/api/v1/statistics/top_revenue_by_category', {}, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      expect(json_response.keys).to all(be_a(String))

      expect(json_response.values).to all(be_an(Array))

      json_response.values.each do |category_list|
        expect(category_list).to all(be_a(Hash))
        expect(category_list).to all(include('id', 'name', 'total_revenue'))
      end
    end

    it 'returns unauthorized when not authenticated' do
      get '/api/v1/statistics/top_revenue_by_category'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /purchases' do
    let(:admin_user) { create(:admin) }

    it 'returns the purchases' do
      start_date = Time.zone.today - rand(1..30).days
      category_id = Category.pluck(:id).sample
      user_id = User.pluck(:id).sample

      get '/api/v1/statistics/purchases', { start_date: start_date, category_id: category_id, user_id: user_id }, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_an(Array)

      json_response.each do |purchase|
        expect(purchase).to be_a(Hash)
        expect(purchase).to include('purchase_id', 'product_id', 'customer_id', 'purchase_date', 'quantity')
      end
    end

    it 'returns an empty hash when no data is available' do
      get '/api/v1/statistics/purchases', { category_id: 99_999 }, auth_headers(admin_user)
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq([])
    end

    it 'returns unauthorized when not authenticated' do
      get '/api/v1/statistics/purchases'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /purchases_by_granularity' do
    let(:admin_user) { create(:admin) }

    it 'returns the purchases by hour' do
      get '/api/v1/statistics/purchases_by_granularity', { granularity: 'hour' }, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      json_response.each do |timestamp, count|
        expect(timestamp).to be_a(String)
        expect(count).to be_an(Integer)
      end
    end

    it 'returns the purchases by granularity by day' do
      get '/api/v1/statistics/purchases_by_granularity', { granularity: 'day' }, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      json_response.each do |date, count|
        expect(date).to be_a(String)
        expect(count).to be_an(Integer)
      end
    end

    it 'returns the purchases by granularity by week' do
      get '/api/v1/statistics/purchases_by_granularity', { granularity: 'week' }, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      json_response.each do |date, count|
        expect(date).to be_a(String)
        expect(count).to be_an(Integer)
      end
    end

    it 'returns the purchases by granularity by year' do
      get '/api/v1/statistics/purchases_by_granularity', { granularity: 'year' }, auth_headers(admin_user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to be_a(Hash)

      json_response.each do |year, count|
        expect(year).to be_a(String)
        expect(year).to match(/^\d{4}$/) # check year
        expect(count).to be_an(Integer)
      end
    end

    it 'returns an empty hash when no data is available' do
      get '/api/v1/statistics/purchases_by_granularity', { granularity: 'hour' }, auth_headers(admin_user)
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq({})
    end

    it 'returns unauthorized when not authenticated' do
      get '/api/v1/statistics/purchases_by_granularity'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
