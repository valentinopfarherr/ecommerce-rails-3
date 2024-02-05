# Purchase class represents a purhcase in the system.
class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer, class_name: 'User'
end
