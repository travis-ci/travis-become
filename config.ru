$:.unshift File.expand_path('../lib', __FILE__)

require 'travis/become'

use Raven::Rack if Travis.config.sentry.dsn

if ENV['BASIC_AUTH_PASSWORD']
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'travis' and password == ENV['BASIC_AUTH_PASSWORD']
  end
end

run Travis::Become.app_for(
  web_endpoint: Travis.config.web_endpoint,
  api_endpoint: Travis.config.api_endpoint,
  admins:       Travis.config.admins
)
