$:.unshift File.expand_path('../lib', __FILE__)

require 'travis/become'
run Travis::Become.app_for(web_endpoint: Travis.config.web_endpoint)
