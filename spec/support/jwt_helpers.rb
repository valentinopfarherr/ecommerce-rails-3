module JwtHelpers
  def auth_headers(user)
    token = generate_jwt(user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  def generate_jwt(user_id)
    payload = { user_id: user_id, exp: 2.hours.from_now.to_i }
    JWT.encode(payload, Ecommerce::Application.config.secret_token)
  end
end
