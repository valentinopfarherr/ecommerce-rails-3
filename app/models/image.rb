# Image class represents a image in the system.
class Image < ActiveRecord::Base
  belongs_to :product

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
