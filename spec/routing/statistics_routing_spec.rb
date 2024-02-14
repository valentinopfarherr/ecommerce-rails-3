require 'rails_helper'

RSpec.describe 'Statistics Routes', type: :routing do
  describe 'API routes' do
    it 'routes GET /api/v1/statistics/most_purchased_by_category to api/v1/statistics#most_purchased_by_category' do
      expect(get('/api/v1/statistics/most_purchased_by_category')).to route_to('api/v1/statistics#most_purchased_by_category')
    end

    it 'routes GET /api/v1/statistics/top_revenue_by_category to api/v1/statistics#top_revenue_by_category' do
      expect(get('/api/v1/statistics/top_revenue_by_category')).to route_to('api/v1/statistics#top_revenue_by_category')
    end

    it 'routes GET /api/v1/statistics/purchases to api/v1/statistics#purchases' do
      expect(get('/api/v1/statistics/purchases')).to route_to('api/v1/statistics#purchases')
    end

    it 'routes GET /api/v1/statistics/purchases_by_granularity to api/v1/statistics#purchases_by_granularity' do
      expect(get('/api/v1/statistics/purchases_by_granularity')).to route_to('api/v1/statistics#purchases_by_granularity')
    end
  end
end
