# Product class represents a product in the system.
class Product < ActiveRecord::Base
  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :images, dependent: :destroy
  has_many :purchase

  before_save :create_images_from_urls

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :reject_images

  validates :name, presence: true, uniqueness: true
  validates :description, :price, presence: true
  has_paper_trail

  private

  def reject_images(attributes)
    attributes['url'].blank?
  end

  def create_images_from_urls
    return unless image_urls.present?

    image_urls.each do |url|
      images.build(url: url)
    end
  end
end
