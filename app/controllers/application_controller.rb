#!/bin/env ruby
# encoding: utf-8
# ApplicationController is the main controller of the application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_paper_trail_whodunnit

  attr_accessor :current_user

  protected

  def paginate_collection(collection)
    per_page = params[:per_page].present? ? params[:per_page] : 10
    collection.page(params[:page]).per(per_page)
  end

  def render_error_response(model)
    render json: { error: model.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']
    token = token.split(' ').last if token
    payload = JWT.decode(token, secret_token).first
    @current_user = User.find_by_id(payload['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    Rails.logger.error "Error durante la autenticación del usuario: #{e.message}"
    render json: { error: 'invalid token' }, status: :unauthorized
  end

  def require_admin_role
    unless @current_user.admin? == true
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def secret_token
    Ecommerce::Application.config.secret_token
  end
end
