# ErrorsController handles errors of the application.
class ErrorsController < ApplicationController
  def not_found
    render json: { error: 'resource not found' }, status: :not_found
  end
end
