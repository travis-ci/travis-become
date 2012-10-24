$:.unshift File.expand_path('../lib', __FILE__)

require 'rack/ssl'
require 'travis/become'
require 'travis/sso'

use Rack::SSL if ENV['RACK_ENV'] == 'production'

use Travis::SSO,
  endpoint:     Travis.config.api_endpoint,
  mode:         :single_page,
  authorized?:  -> u { Travis.config.admins.include? u['login'] }

run Travis::Become.new(web_endpoint: Travis.config.web_endpoint)
