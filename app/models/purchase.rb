class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer, class_name: 'User'
end
