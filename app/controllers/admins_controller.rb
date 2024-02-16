# AdminsController handles CRUD operations for admins.
class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter -> { require_admin_role }
  before_filter :set_admin, only: [:show, :update, :destroy]

  def index
    render json: paginate_collection(Admin.where(role: 'admin'))
  end

  # Shows a specific admin.
  def show
    render json: @admin, status: :ok
  end

  # Creates a new admin.

  def create
    @admin = Admin.new(params[:admin])
    @admin.role = 'admin'

    if @admin.save
      token = @admin.generate_jwt
      render json: { admin: @admin, token: token }, status: :created
    else
      render_error_response(@admin)
    end
  end

  # Updates an existing admin.
  def update
    if @admin.update_attributes(params[:admin])
      render json: @admin
    else
      render_error_response(@admin)
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

  # Sets the admin for the actions that need it.
  def set_admin
    @admin = Admin.find_by_id(params[:id])
    render json: { error: 'admin not found' }, status: :not_found unless @admin.try(:role) == 'admin'
  end
end
