require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Tubeyou
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config_file = 'config/aws_config.yml'
    config = YAML.load(File.read(config_file))
    AWS.config(config)
    $S3 = AWS::S3.new( :region => "us-east-1" )
    ENV['cf_http_url'] = "http://d3e3zsnth95ia5.cloudfront.net/"
    ENV['cf_stream_rul'] = "rtmp://s2ey2hbk14ns94.cloudfront.net/"
  end
end
