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

  private

  def render_error_response(model)
    render json: { error: model.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  def encode_token(payload)
    payload[:exp] = 2.hours.from_now.to_i
    JWT.encode(payload, Ecommerce::Application.config.secret_token)
  end

  def authenticate_user!
    token = request.headers['Authorization']
    token = token.split(' ').last if token
    decoded_token = JWT.decode(token, Ecommerce::Application.config.secret_token)
    @current_user = User.find(decoded_token.first['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'invalid token' }, status: :unauthorized
  end

  def require_role(role)
    unless @current_user.role == role
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
