FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    creator_id { User.where(role: 'admin').pluck(:id).sample }
  end
end
