# PurchasesController handles CRUD operations for products.
class PurchasesController < ApplicationController
  before_filter :set_purchase, only: [:show, :update, :destroy]
  before_filter :set_buyer_and_product, only: [:create]

  def index
    @purchases = Purchase.all
    render json: @purchases
  end

  # Shows a specific purchase.
  def show
    if @purchase
      render json: @purchase
    else
      render json: [], status: :ok
    end
  end

  # Creates a new purchase.
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.purchase_date = Time.zone.now

    if @purchase.save
      render json: @purchase, status: :created, location: @purchase
    else
      render json: { error: @purchase.errors.full_messages.join(', ') }, status: :unprocessable_entity
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

  # Defines the parameters required for a purchase.
  def purchase_params
    params.require(:purchase).permit(:buyer_id, :product_id)
  end

  # Sets the purchase for the actions that need it.
  def set_purchase
    @purchase = Purchase.find_by_id(params[:id])
    render json: { error: 'purchase not found' }, status: :not_found unless @purchase
  end

  # Sets the buyer and the product for the actions that need it.
  def set_buyer_and_product
    @buyer = Buyer.find_by_id(params[:buyer_id])
    @product = Product.find_by_id(params[:product_id])

    unless @buyer && @product
      render json: { error: 'the buyer or the product does not exist' }, status: :not_found
    end
  end
end
