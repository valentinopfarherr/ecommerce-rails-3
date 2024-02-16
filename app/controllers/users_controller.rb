# UsersController handles CRUD operations for users.
class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_filter -> { require_admin_role }, except: [:create]
  before_filter :set_user, only: [:show, :update, :destroy]

  def index
    render json: paginate_collection(User.where(role: 'buyer'))
  end

  # Shows a specific user.
  def show
    render json: @user, status: :ok
  end

  # Creates a new user.

  def create
    @user = User.new(params[:user])
    @user.role = 'buyer'

    if @user.save
      token = @user.generate_jwt
      render json: { user: @user, token: token }, status: :created
    else
      render_error_response(@user)
    end
  end

  # Updates an existing user.
  def update
    if @user.update_attributes(params[:user])
      render json: @user
    else
      render_error_response(@user)
    end
  end

  # Deletes a user.
  def destroy
    if @user.destroy
      render json: { message: 'user deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete user' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the user for the actions that need it.
  def set_user
    @user = User.find_by_id(params[:id])
    render json: { error: 'user not found' }, status: :not_found unless @user.try(:role) == 'buyer'
  end
end
