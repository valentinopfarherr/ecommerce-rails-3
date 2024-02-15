module JwtHelper
  def encode_token(payload)
    payload[:exp] = 2.hours.from_now.to_i
    JWT.encode(payload, Ecommerce::Application.config.secret_token)
  end

  def decode_token(token)
    JWT.decode(token, Ecommerce::Application.config.secret_token)
  end
end
