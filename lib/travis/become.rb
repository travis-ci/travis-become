require 'httparty'
require 'travis/become/config'
require 'travis/become/token'
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

    def self.config
      @config ||= Config.load
    end

    def initialize(options = {})
      @api_endpoint = options.fetch(:api_endpoint)
      @web_endpoint = options.fetch(:web_endpoint)
      template_file = options.fetch(:template_file, TEMPLATE_FILE)
      @template     = options.fetch(:template) { File.read(template_file) }
    end

    def call(env)
      login = env['PATH_INFO'].gsub(/^\//, '')

      if login.empty? || login == "favicon.ico"
        response = Rack::Response.new("route / not found, you most likely want /{login}", 404)
        response.finish
        return response
      end

      response = HTTParty.get("#{@api_endpoint}/v3/owner/#{login}")
      user = JSON.parse(response.body)

      if user
        data = user
        data['token'] = user.tokens.first.try(:token).to_s
        response = Rack::Response.new(template % {
          user:   Rack::Utils.escape_html(data.to_json),
          token:  Travis::Api::App::AccessToken.create(user: user, app_id: 0),
          action: web_endpoint
        })
      else
        response = Rack::Response.new("could not find user #{login.inspect}", 404)
      end

      response.finish
    end
  end
end
