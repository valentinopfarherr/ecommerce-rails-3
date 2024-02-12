# Controller for handling buyer sessions.
class BuyerSessionsController < ApplicationController
  def create
    customer = Customer.find_by(email: params[:email])
    if customer && customer.authenticate(params[:password])
      token = generate_token(customer)
      render json: { token: token }
    else
      render json: { error: 'invalid username or password' }, status: :unauthorized
    end
  end

  private

  def generate_token(customer)
    payload = { customer_id: customer.id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
