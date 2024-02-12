# BuyerController handles CRUD operations for buyers.
class BuyersController < ApplicationController
  # before_filter :authenticate_buyer!
  before_filter :set_buyer, only: [:show, :update, :destroy]

  def index
    @buyers = Buyer.where(role: 'buyer')
    render json: @buyers
  end

  # Shows a specific buyer.
  def show
    if @buyer
      render json: @buyer
    else
      render json: [], status: :ok
    end
  end

  # Creates a new buyer.

  def create
    @buyer = Buyer.new(buyer_params)
    @buyer.role = 'buyer'

    if @buyer.save
      render json: @buyer, status: :created
    else
      render json: { error: @buyer.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # Updates an existing buyer.
  def update
    if @buyer.update_attributes(buyer_params)
      render json: @buyer
    else
      render json: { error: @buyer.errors.full_messages.join(', ') }, status: :unprocessable_entity
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

  def buyer_params
    params.require(:buyer).permit(:username, :password, :email)
  end

  # Sets the buyer for the actions that need it.
  def set_buyer
    @buyer = Buyer.find_by_id(params[:id])
    unless @buyer && @buyer.role == 'buyer'
      render json: { error: 'buyer not found' }, status: :not_found
    end
  end

  def authenticate_buyer!
    token = request.headers['Authorization'].to_s.split(' ').last
    unless token && valid_token?(token)
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
    decoded_token['buyer_id'].present? && Buyer.exists?(decoded_token['buyer_id'])
  rescue JWT::DecodeError
    false
  end
end
