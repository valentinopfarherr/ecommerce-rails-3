#!/bin/env ruby
# encoding: utf-8
# ApplicationController is the main controller of the application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def paginate_collection(collection)
    per_page = params[:per_page].present? ? params[:per_page] : 10
    collection.page(params[:page]).per(per_page)
  end

  def render_error_response(model)
    render json: { error: model.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  def authenticate_user!
    token = request.headers['Authorization']
    token = token.split(' ').last if token
    payload = JWT.decode(token, secret_token).first
    @current_user = User.find_by_id(payload['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'invalid token' }, status: :unauthorized
  end

  private

  def require_admin_role
    unless @current_user.admin? == true
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def secret_token
    Ecommerce::Application.config.secret_token
  end

  def set_paper_trail_whodunnit
    PaperTrail.whodunnit = @current_user.id.to_s if @current_user
  end
end
