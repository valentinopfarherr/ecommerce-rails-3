# CategoriesController handles CRUD operations for categories.
class CategoriesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter -> { require_role('admin') }, except: [:index, :show]
  before_filter :set_category, only: [:show, :update, :destroy, :history]
  before_filter :set_paper_trail_whodunnit

  def index
    render json: paginate_collection(Category)
  end

  # Shows a specific category.
  def show
    render json: @category, status: :ok
  end

  # Creates a new category.
  def create
    @category = Category.new(params[:category])
    @category.creator_id = @current_user.id

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render_error_response(@category)
    end
  end

  # Updates an existing category.
  def update
    if @category.update_attributes(params[:category])
      render json: @category
    else
      render_error_response(@category)
    end
  end

  # Deletes a category.
  def destroy
    if @category.destroy
      render json: { message: 'category deleted successfully' }, status: :ok
    else
      render json: { error: 'failed to delete category' }, status: :unprocessable_entity
    end
  end

  # Show history of a category
  def history
    @history = @category.versions.reverse_order.map do |version|
      category_info = version.object.present? ? YAML.load(version.object) : @category
      {
        occurred_at: version.created_at,
        action: version.event,
        category: category_info,
        admin_id: version.whodunnit
      }
    end
    render json: @history
  end

  private

  # Sets the category for the actions that need it.
  def set_category
    @category = Category.find_by_id(params[:id])
    render json: { error: 'category not found' }, status: :not_found unless @category
  end
end
