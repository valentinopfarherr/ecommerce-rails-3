# ProductCategory class represents the association between products and categories.
class ProductCategory < ActiveRecord::Base
  belongs_to :product
  belongs_to :category
end
