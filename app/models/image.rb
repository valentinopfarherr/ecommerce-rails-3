# Image class represents a image in the system.
class Image < ActiveRecord::Base
  belongs_to :product
end
