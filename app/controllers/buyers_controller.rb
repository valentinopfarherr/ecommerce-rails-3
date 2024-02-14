# BuyerController handles CRUD operations for buyers.
class BuyersController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_filter -> { require_role('admin') }, except: [:create]
  before_filter :set_buyer, only: [:show, :update, :destroy]

  def index
    render json: paginate_collection(Buyer.where(role: 'buyer'))
  end

  # Shows a specific buyer.
  def show
    render json: @buyer, status: :ok
  end

  # Creates a new buyer.

  def create
    @buyer = Buyer.new(params[:buyer])
    @buyer.role = 'buyer'

    if @buyer.save
      token = encode_token(user_id: @buyer.id)
      render json: { buyer: @buyer, token: token }, status: :created
    else
      render_error_response(@buyer)
    end
  end

  # Updates an existing buyer.
  def update
    if @buyer.update_attributes(params[:buyer])
      render json: @buyer
    else
      render_error_response(@buyer)
    end
  end

  # Deletes a buyer.
  def destroy
    if @buyer.destroy
      render json: { message: 'buyer deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete buyer' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the buyer for the actions that need it.
  def set_buyer
    @buyer = Buyer.find_by_id(params[:id])
    render json: { error: 'buyer not found' }, status: :not_found unless @buyer.try(:role) == 'buyer'
  end
end
