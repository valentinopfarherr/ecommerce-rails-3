# require 'rails_helper'

# RSpec.describe Api::V1::StatisticsService do
#   describe ".most_purchased_by_category" do
#     it "returns a hash of most purchased products by category" do
#       category = create(:category)
#       product1 = create(:product)
#       product2 = create(:product)

#       create(:purchase, product: product1, quantity: 10)
#       create(:purchase, product: product1, quantity: 5)
#       create(:purchase, product: product2, quantity: 8)

#       result = described_class.most_purchased_by_category

#       expect(result).to be_a(Hash)
#       expect(result[category.id]).to include(
#         { id: product1.id, name: product1.name, total_purchases: 15 },
#         { id: product2.id, name: product2.name, total_purchases: 8 }
#       )
#     end
#   end

#   describe ".top_revenue_by_category" do
#     it "returns a hash of top revenue products by category" do
#       category = create(:category)
#       product1 = create(:product, price: 10)
#       product2 = create(:product, price: 20)

#       create(:purchase, product: product1, quantity: 5)
#       create(:purchase, product: product1, quantity: 3)
#       create(:purchase, product: product2, quantity: 2)

#       result = described_class.top_revenue_by_category

#       expect(result).to be_a(Hash)
#       expect(result[category.id]).to include(
#         { id: product1.id, name: product1.name, total_revenue: 80.0 },
#         { id: product2.id, name: product2.name, total_revenue: 40.0 }
#       )
#     end
#   end
# end
