$:.unshift File.expand_path('../lib', __FILE__)

require 'raven'
require 'travis/become'

use Raven::Rack if Travis::Become.config.sentry.dsn

if ENV['BASIC_AUTH_PASSWORD']
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'travis' and password == ENV['BASIC_AUTH_PASSWORD']
  end
end

run Travis::Become.app_for(
  web_endpoint: Travis::Become.config.web_endpoint,
  api_endpoint: Travis::Become.config.api_endpoint,
  admins:       Travis::Become.config.admins
)
