source 'https://rubygems.org'

gem 'travis-support',  github: 'travis-ci/travis-support'
gem 'travis-core',     github: 'travis-ci/travis-core'
gem 'travis-sidekiqs', github: 'travis-ci/travis-sidekiqs', require: nil, ref: 'cde9741'
gem 'mustermann',      github: 'rkh/mustermann'
gem 'sinatra',         github: 'sinatra/sinatra'
gem 'sinatra-contrib', github: 'sinatra/sinatra-contrib', require: nil

gem 'travis-api', github: "travis-ci/travis-api", ref: 'sf-bump-pg'
gem 'travis-sso', github: "travis-ci/travis-sso"
gem 'travis-config', '~> 0.1.0'

gem 'simple_states'

gem 'active_model_serializers'
gem 'unicorn'
gem 'sentry-raven',    github: 'getsentry/raven-ruby'
gem 'yard-sinatra',    github: 'rkh/yard-sinatra'
gem 'rack-contrib',    github: 'rack/rack-contrib'
gem 'rack-cache',      github: 'rtomayko/rack-cache'
gem 'rack-attack'
gem 'gh'
gem 'bunny',           '~> 0.8.0'
gem 'dalli'
gem 'pry'
gem 'pg',              '~> 0.15.0'
gem 'metriks',         '0.9.9.6'
gem 'metriks-librato_metrics', github: 'eric/metriks-librato_metrics'
gem 'micro_migrations'
gem 'simplecov'
gem 'skylight', '~> 0.6.0.beta.1'
gem 'stackprof'

group :test do
  gem 'rspec',        '~> 2.11'
  gem 'factory_girl', '~> 2.4.0'
  gem 'mocha',        '~> 0.12'
  gem 'database_cleaner', '~> 0.8.0'
end

group :development do
  gem 'foreman'
  gem 'rerun'
end

group :development, :test do
  gem 'rake', '~> 0.9.2'
end

group :test do
  gem 'flexmock'
end
