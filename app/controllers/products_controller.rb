# ProductsController handles CRUD operations for products.
class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter -> { require_admin_role }, except: [:index, :show]
  before_filter :set_product, only: [:show, :update, :destroy, :history]
  before_filter :set_paper_trail_whodunnit, only: [:create, :update]

  def index
    render json: paginate_collection(Product.includes(:images, :categories))
  end

  # Shows a specific product.
  def show
    render json: @product, status: :ok
  end

  # Creates a new product.
  def create
    @product = Product.new(params[:product])
    @product.creator_id = @current_user.id
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render_error_response(@product)
    end
  end

  # Updates an existing product.
  def update
    delete_images_and_categories_if_necessary(@product, params[:product][:images_attributes], params[:product][:product_categories_attributes])
    if @product.update_attributes(params[:product])
      render json: @product
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
    versions_info = @product.versions.reverse_order.map do |version|
      product_info = version.object.present? ? YAML.load(version.object) : {}
      {
        event: version.event,
        occurred_at: version.created_at,
        product: product_info,
        whodunnit: version.whodunnit
      }
    end
    render json: versions_info
  end

  private

  # Sets the product for the actions that need it.
  def set_product
    @product = Product.find_by_id(params[:id])
    render json: { error: 'product not found' }, status: :not_found unless @product
  end

  def delete_images_and_categories_if_necessary(product, images_params, categories_params)
    product.images.clear if images_params.present?
    product.product_categories.clear if categories_params.present?

    product.save
  end
end
