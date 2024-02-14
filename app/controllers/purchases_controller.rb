# PurchasesController handles CRUD operations for products.
class PurchasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter -> { require_role('admin') }, except: [:create]
  before_filter :set_purchase, only: [:show, :update, :destroy]
  before_filter :set_product, only: [:create]

  def index
    render json: paginate_collection(Purchase)
  end

  # Shows a specific purchase.
  def show
    render json: @purchase, status: :ok
  end

  # Creates a new purchase.
  def create
    @purchase = Purchase.new(params[:purchase])
    @purchase.purchase_date = Time.zone.now
    @purchase.customer_id = @current_user.id

    if @purchase.save
      @purchase.product.send_first_purchase_email_if_needed
      render json: @purchase, status: :created, location: @purchase
    else
      render_error_response(@purchase)
    end
  end

  # Deletes a purhcase.
  def destroy
    if @purchase.destroy
      render json: { message: 'purchase deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete purchase' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the purchase for the actions that need it.
  def set_purchase
    @purchase = Purchase.find_by_id(params[:id])
    render json: { error: 'purchase not found' }, status: :not_found unless @purchase
  end

  # Sets the product for the actions that need it.
  def set_product
    @product = Product.find_by_id(params[:product_id])
    render json: { error: 'the product does not exist' }, status: :not_found unless @product
  end
end
