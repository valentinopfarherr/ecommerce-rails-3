# CategoriesController handles CRUD operations for categories.
class CategoriesController < ApplicationController
  before_filter :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
    render json: @categories
  end

  # Shows a specific category.
  def show
    if @category
      render json: @category
    else
      render json: [], status: :ok
    end
  end

  # Creates a new category.
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: { error: @category.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # Updates an existing category.
  def update
    if @category.update_attributes(category_params)
      render json: @category
    else
      render json: { error: @category.errors.full_messages.join(', ') }, status: :unprocessable_entity
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

  private

  # Defines the parameters required for a category.
  def category_params
    params.require(:category).permit(:name)
  end

  # Sets the category for the actions that need it.
  def set_category
    @category = Category.find_by_id(params[:id])
    render json: { error: 'category not found' }, status: :not_found unless @category
  end
end
