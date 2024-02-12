# ProductsController handles CRUD operations for products.
class ProductsController < ApplicationController
  before_filter :set_product, only: [:show, :update, :destroy]

  # Includes avoid N + 1 problem
  def index
    @products = Product.includes(:images).all
    render_products_with_images(@products)
  end

  # Shows a specific product.
  def show
    render_product_with_images(@product)
  end

  # Creates a new product.
  def create
    puts "a"
    puts product_params
    @product = Product.new(product_params, images_attributes: product_params[:images_attributes])
    if @product.save
      render_product_with_images(@product, :created)
    else
      render json: { error: @product.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # Updates an existing product.
  def update
    if @product.update_attributes(product_params)
      render_product_with_images(@product)
    else
      render json: { error: @product.errors.full_messages.join(', ') }, status: :unprocessable_entity
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

  private

  # Defines the parameters required for a product.
  def product_params
    params.require(:product).permit(:name, :price, :description, :category_id, { :image_urls => []})
  end

  # Sets the product for the actions that need it.
  def set_product
    @product = Product.find_by_id(params[:id])
    render json: { error: 'product not found' }, status: :not_found unless @product
  end

  def render_product_with_images(product, status = :ok)
    render json: product.as_json(include: :images), status: status, location: @products
  end

  def render_products_with_images(products)
    render json: products.as_json(include: :images)
  end
end
