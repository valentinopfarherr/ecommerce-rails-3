# Controller for handling admin sessions.
class AdminSessionsController < ApplicationController
  def create
    admin = Admin.find_by(username: params[:username])
    if admin && admin.authenticate(params[:password])
      token = generate_token(admin)
      render json: { token: token }
    else
      render json: { error: 'invalid username or password' }, status: :unauthorized
    end
  end

  private

  def generate_token(admin)
    payload = { admin_id: admin.id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
