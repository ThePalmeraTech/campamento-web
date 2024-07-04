require_relative "boot"

require "rails/all"
require 'pundit'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Rails.load


module Webdevworkshop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

     # Default URL options for Action Mailer
     config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } if Rails.env.development?
     config.action_mailer.default_url_options = { host: 'yourdomain.com' } if Rails.env.production?
   end
  end
