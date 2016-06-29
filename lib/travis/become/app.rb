require 'travis/become'

require 'sinatra'
require 'sinatra/multi_route'

require 'travis/become/config'
require 'travis/become/access_token'
require 'travis/become/model/token'
require 'travis/become/model/permission'
require 'travis/become/model/repository'
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

  begin
    login_column = Travis::Become::User.arel_table[:login]
    user = Travis::Become::User.where(login_column.lower.eq(login.downcase)).first

    data = user.data

    @user = Rack::Utils.escape_html(data.to_json)
    @token = Travis::Become::AccessToken.create(user_id: user.id, app_id: 0)
    @action = WE_ENDPOINT

    erb :become
  rescue ActiveRecord::RecordNotFound
    status 404
    body "could not find user #{login.inspect}"
  end
end