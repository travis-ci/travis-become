$:.unshift File.expand_path('../lib', __FILE__)

require 'raven'
require 'travis/sso'
require 'rack'
require 'rack/ssl'
require 'travis/become'
require 'travis/become/app'

use Raven::Rack if Travis::Become.config.sentry.dsn

if ENV['BASIC_AUTH_PASSWORD']
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'travis' and password == ENV['BASIC_AUTH_PASSWORD']
  end
end

use Rack::CommonLogger
use Rack::SSL if ENV['RACK_ENV'] == 'production'
use Travis::SSO,
  endpoint:     Travis::Become.config.api_endpoint,
  mode:         :single_page,
  authorized?:  -> u { Travis::Become.config.admins.include? u['login'] }
use Rack::ShowExceptions

run Sinatra::Application
