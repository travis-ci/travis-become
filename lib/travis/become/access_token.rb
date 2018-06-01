require 'securerandom'
require 'redis'

module Travis
  class Become
    class AccessToken
      DEFAULT_SCOPES = [:public, :private]
      attr_reader :token, :scopes, :user_id, :app_id, :extra

      def self.create(options = {})
        new(options).tap(&:save)
      end

      def initialize(options = {})
        raise ArgumentError, 'must supply user_id' unless options.key?(:user_id)
        raise ArgumentError, 'must supply app_id' unless options.key?(:app_id)

        @app_id   = Integer(options[:app_id])
        @scopes   = Array(options[:scopes] || options[:scope] || DEFAULT_SCOPES).map(&:to_sym)
        @user_id  = Integer(options[:user_id])
        @token    = options[:token] || reuse_token || SecureRandom.urlsafe_base64(16)
        @extra    = options[:extra]
      end

      def save
        key = key(token)
        redis.del(key)
        data = [user_id, app_id, *scopes]
        data << encode_json(extra) if extra
        redis.rpush(key, data.map(&:to_s))
        redis.set(reuse_key, token)
      end

      def user
        @user ||= User.find(user_id) if user_id
      end

      def user?
        !!user
      end

      def to_s
        token
      end

      private

        def redis
          Thread.current[:redis] ||= ::Redis.new(url: Travis::Become.config.redis.url)
        end

        def key(token)
          "t:#{token}"
        end

        def encode_json(hash)
          'json:' + Base64.encode64(hash.to_json)
        end

        def decode_json(json)
          JSON.parse(Base64.decode64(json.gsub(/^json:/, '')))
        end

        def reuse_token
          redis.get(reuse_key)
        end

        def reuse_key
          @reuse_key ||= begin
            keys = ["r", user_id, app_id]
            keys.append(scopes.map(&:to_s).sort) if scopes != DEFAULT_SCOPES
            keys.join(':')
          end
        end
    end
  end
end
