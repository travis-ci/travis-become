require 'travis/become'

require 'sinatra'
require 'sinatra/multi_route'

require 'httparty'
require 'travis/become/config'
require 'travis/become/access_token'
require 'travis/become/model/token'
require 'travis/become/model/user'
require 'travis/become/support/database'
require 'json'

API_ENDPOINT = Travis::Become.config.api_endpoint
WE_ENDPOINT = Travis::Become.config.web_endpoint

Travis::Become::Database.connect(ActiveRecord::Base, Travis::Become.config.database)

route :get, :post, '/favicon.ico' do
  status 404
  body 'route / not found, you most likely want /{login}'
end

route :get, :post, '/' do
  status 404
  body 'route / not found, you most likely want /{login}'
end

route :get, :post, '/:login' do
  login = params['login']

  api_response = HTTParty.get("#{API_ENDPOINT}/v3/owner/#{login}")
  api_user = JSON.parse(api_response.body)
  user_id = api_user['id']

  user = Travis::Become::User.find(user_id)

  if user
    data = api_user
    data['token'] = user.tokens.first.try(:token).to_s

    @user = Rack::Utils.escape_html(data.to_json)
    @token = Travis::Become::AccessToken.create(user_id: user_id, app_id: 0)
    @action = WE_ENDPOINT

    erb :become
  else
    status 404
    body "could not find user #{login.inspect}"
  end
end
