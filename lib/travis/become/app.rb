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
require 'addressable/uri'

API_ENDPOINT = Travis::Become.config.api_endpoint
WEB_ENDPOINT = Travis::Become.config.web_endpoint
WEB_ENDPOINT_BILLING = Travis::Become.config.web_endpoint_billing

Travis::Become::Database.connect

route :get, :post, '/favicon.ico' do
  status 404
  body 'route / not found, you most likely want /{login}'
end

route :get, :post, '/' do
  status 404
  body 'route / not found, you most likely want /{login}'
end


route :get, :post, '/id/:id' do
  handle_login(params, :by_id)
end

route :get, :post, '/:login' do
  handle_login(params, :by_login)
end

def handle_login(params, type)
  begin
    if type == :by_id
      user = Travis::Become::User.find_by(id:  params['id'])
    else
      login_column = Travis::Become::User.arel_table[:login]
      user = Travis::Become::User.where(login_column.lower.eq(params['login'].downcase)).first
    end

    data = user.data

    @user = Rack::Utils.escape_html(data.to_json)
    # @token = data[:web_token]
    web_token = data[:web_token]
    redis_web_token = "t:#{web_token}"
    unless web_token.blank?

      if Travis.redis.exists(redis_web_token).zero?
        web_token.destroy
        web_token = @user.tokens.web.create!
        puts "New Web Token: #{web_token}"
      end

      @token = Travis::Become::AccessToken.create(user: user, app_id: app_id, token: web_token.token,
                     do_not_reuse: true)
    end
    puts "TOKEN from handle_login IS #{@token}"
    @action = WEB_ENDPOINT
    if WEB_ENDPOINT_BILLING
      if params[:billing] == '1' || params[:billing] == 'true'
        @action = WEB_ENDPOINT_BILLING
      end
    end

    if params[:host]
      uri = Addressable::URI.parse("https://#{Rack::Utils.escape_html(params[:host])}")

      if uri
        if uri.host =~ /\A(.+\.)?travis-ci\.(com|org)\Z/
          @action = uri.to_s
        end
      end
    end

    erb :become
  rescue ActiveRecord::RecordNotFound
    status 404
    body "could not find user #{login.inspect}"
  end
end
