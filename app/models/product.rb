# Product class represents a product in the system.
class Product < ActiveRecord::Base
  has_paper_trail

  attr_accessible :name, :price, :description, :images_attributes, :product_categories_attributes

  belongs_to :creator, class_name: 'Admin'
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :images, dependent: :destroy
  has_many :purchases

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :reject_images
  accepts_nested_attributes_for :product_categories

  validates :name, presence: true, uniqueness: true
  validates :description, :price, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :unique_images
  validate :unique_categories
  validate :existing_categories

  def self.seed_attributes
    attr_accessible :creator_id
  end

  def send_first_purchase_email_if_needed
    # avoiding race condition
    self.class.transaction do
      reload
      unless first_purchase_email_sent?
        admin_creator = creator
        cc_admins = User.where("role = 'admin' AND id != ?", creator.id)
        self.class.where(id: id).update_all(first_purchase_email_sent: true)
        EmailService.send_admin_first_purchase_email(self, admin_creator, cc_admins)
      end
    end
  end

  private

  def reject_images(attributes)
    attributes['url'].blank?
  end

  def unique_images
    images.each do |image|
      if images.select { |i| i.url == image.url }.count > 1
        errors.add(:base, 'Cannot have duplicate images')
        break
      end
    end
  end

  def unique_categories
    if product_categories.group_by(&:category_id).values.any? { |categories| categories.size > 1 }
      errors.add(:base, 'Cannot have duplicate categories')
    end
  end

  def existing_categories
    invalid_categories = product_categories.reject(&:valid_category?)
    invalid_categories.each do |product_category|
      errors.add(:base, "Category with ID #{product_category.category_id} does not exist")
    end
  end
end
