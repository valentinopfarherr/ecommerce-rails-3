# AdminsController handles CRUD operations for admins.
class AdminsController < ApplicationController
  # before_filter :authenticate_admin!
  before_filter :set_admin, only: [:show, :update, :destroy]

  def index
    @admins = Admin.where(role: 'admin')
    render json: @admins
  end

  # Shows a specific admin.
  def show
    if @admin
      render json: @admin
    else
      render json: [], status: :ok
    end
  end

  # Creates a new admin.

  def create
    @admin = Admin.new(admin_params)
    @admin.role = 'admin'

    if @admin.save
      render json: @admin, status: :created
    else
      render json: { error: @admin.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # Updates an existing admin.
  def update
    if @admin.update_attributes(admin_params)
      render json: @admin
    else
      render json: { error: @admin.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # Deletes an admin.
  def destroy
    if @admin.destroy
      render json: { message: 'admin deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete admin' }, status: :unprocessable_entity
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :password, :email)
  end

  # Sets the admin for the actions that need it.
  def set_admin
    @admin = Admin.find_by_id(params[:id])
    unless @admin && @admin.role == 'admin'
      render json: { error: 'admin not found' }, status: :not_found
    end
  end

  def authenticate_admin!
    token = request.headers['Authorization'].to_s.split(' ').last
    unless token && valid_token?(token)
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
    decoded_token['admin_id'].present? && Admin.exists?(decoded_token['admin_id'])
  rescue JWT::DecodeError
    false
  end
end
