$:.unshift File.expand_path('../lib', __FILE__)

require 'rack/ssl'
require 'travis/become'
require 'travis/sso'

use Rack::SSL if ENV['RACK_ENV'] == 'production'

admins = ENV.fetch('TRAVIS_ADMINS').split(',')
use Travis::SSO,
  endpoint:     ENV.fetch('API_ENDPOINT'),
  mode:         :single_page,
  authorized?:  -> u { admins.include? u['login'] }

run Travis::Become.new(web_endpoint: ENV.fetch('WEB_ENDPOINT'))
