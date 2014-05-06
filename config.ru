# This file is used by Rack-based servers to start the application.

require 'rack'
require 'rack/contrib'

use Rack::JSONP
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
