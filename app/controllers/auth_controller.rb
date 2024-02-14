# AuthController handles authentication for admins & buyers.
class AuthController < ApplicationController
  def login
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: 'invalid email or password' }, status: :unauthorized
    end
  end
end
