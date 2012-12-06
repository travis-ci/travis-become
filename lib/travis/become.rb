require 'travis'
require 'travis/api/app/access_token'
require 'travis/sso'
require 'rack'
require 'rack/ssl'
require 'json'

module Travis
  class Become
    TEMPLATE_FILE = File.expand_path('../become.html', __FILE__)
    attr_accessor :web_endpoint, :template

    def self.app_for(options)
      admins = options.fetch(:admins)
      Rack::Builder.app(new(options)) do
        use Rack::CommonLogger
        use Rack::SSL if ENV['RACK_ENV'] == 'production'
        use Travis::SSO,
          endpoint:     options.fetch(:api_endpoint),
          mode:         :single_page,
          authorized?:  -> u { admins.include? u['login'] }
        use Rack::ShowExceptions
      end
    end

    def initialize(options = {})
      Travis::Database.connect
      @web_endpoint = options.fetch(:web_endpoint)
      template_file = options.fetch(:template_file, TEMPLATE_FILE)
      @template     = options.fetch(:template) { File.read(template_file) }
    end

    def call(env)
      login = env['PATH_INFO'].gsub(/^\//, '')
      user  = User.find_by_login(login)

      if user
        response = Rack::Response.new(template % {
          user:   Travis::Api::data(user, version: :v2)['user'].to_json,
          token:  Travis::Api::App::AccessToken.create(user: user, app_id: 0),
          action: web_endpoint
        })
      else
        response = Rack::Response.new("could not find user #{login.inspect}", 400)
      end

      response.finish
    end
  end
end
