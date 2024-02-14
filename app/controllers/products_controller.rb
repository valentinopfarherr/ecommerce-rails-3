# ProductsController handles CRUD operations for products.
class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter -> { require_role('admin') }, except: [:index, :show]
  before_filter :set_product, only: [:show, :update, :destroy, :history]
  before_filter :set_paper_trail_whodunnit

  def index
    render_product_response(paginate_collection(Product.includes(:images, :categories)))
  end

  # Shows a specific product.
  def show
    render_product_response(@product)
  end

  # Creates a new product.
  def create
    @product = Product.new(params[:product])
    @product.creator_id = @current_user.id
    if @product.save
      render_product_response(@product, :created)
    else
      render_error_response(@product)
    end
  end

  # Updates an existing product.
  def update
    delete_images_and_categories_if_necessary(@product, params[:product][:images_attributes], params[:product][:product_categories_attributes])
    if @product.update_attributes(params[:product])
      render_product_response(@product)
    else
      render_error_response(@product)
    end
  end

  # Deletes a product.
  def destroy
    if @product.destroy
      render json: { message: 'product deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete product' }, status: :unprocessable_entity
    end
  end

  # Show history of a product
  def history
    @history = @product.versions.reverse_order.map do |version|
      pruduct_info = version.object.present? ? YAML.load(version.object) : {}
      {
        occurred_at: version.created_at,
        action: version.event,
        product: pruduct_info,
        admin_id: version.whodunnit
      }
    end
    render json: @history
  end

  private

  # Sets the product for the actions that need it.
  def set_product
    @product = Product.find_by_id(params[:id])
    render json: { error: 'product not found' }, status: :not_found unless @product
  end

  # Renders the product response including images and categories.
  def render_product_response(product, status = :ok)
    render json: product.as_json(
      include: {
        images: {
          only: [:id, :url]
        },
        categories: {
          only: [:id, :name]
        }
      }
    ), status: status
  end

  def delete_images_and_categories_if_necessary(product, images_params, categories_params)
    product.images.clear if images_params.present?
    product.product_categories.clear if categories_params.present?

    product.save
  end
end
