require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
# 

module Rack
     class JSONP

        def call(env)
      # remove the callback and _ parameters BEFORE calling the backend, so
      # that caching middleware does not store a copy for each value of the
      # callback parameter
      Rails.logger.debug("here I am!")
      puts "for real"
      request = Rack::Request.new(env)
      callback = request.params.delete(@callback_param)
      puts "callback #{callback}"
      timestamp = request.params.delete(@timestamp_param)
      env['QUERY_STRING'] = env['QUERY_STRING'].split("&").delete_if{|param|
        param =~ /^(#{@timestamp_param}|#{@callback_param})=/
      }.join("&")
      env['rack.jsonp.callback'] = callback
      env['rack.jsonp.timestamp'] = timestamp


      puts "content type #{headers['Content-Type']}"
      status, headers, response = @app.call(env)

      if callback && headers['Content-Type'] =~ /json/i
        response = pad(callback, response)
        headers['Content-Length'] = response.first.bytesize.to_s
        headers['Content-Type'] = 'application/javascript'
      elsif @carriage_return && headers['Content-Type'] =~ /json/i
        # add a \n after the response if this is a json (not JSONP) response
        response = carriage_return(response)
        headers['Content-Length'] = response.first.bytesize.to_s
      end

      [status, headers, response]
    end

    end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Todo
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
    # 
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
