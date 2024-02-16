# SessionsController handles authentication for admins & users.
class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = user.generate_jwt
      render json: { token: token }
    else
      render json: { error: 'invalid email or password' }, status: :unauthorized
    end
  end
end
