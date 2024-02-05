require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w(development test)))
end

module Ecommerce
  # Main application class for the Ecommerce application
  class Application < Rails::Application
    config.encoding = 'utf-8'

    config.filter_parameters += [:password]

    config.assets.enabled = true

    config.assets.version = '1.0'

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
