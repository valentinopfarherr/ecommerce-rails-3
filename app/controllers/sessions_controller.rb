#!/bin/env ruby
# encoding: utf-8

class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      token = generate_token(user)
      session[:user_id] = user.id
      render json: { token: token, message: 'Inicio de sesión exitoso' }, status: :ok
    else
      render json: { error: 'Usuario o contraseña incorrectos' }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { message: 'Sesión cerrada correctamente' }, status: :ok
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'Usuario creado exitosamente' }, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def generate_token(user)
    payload = { user_id: user.id }
    secret_key = Rails.application.secrets.secret_key_base
    JWT.encode(payload, secret_key)
  end
end