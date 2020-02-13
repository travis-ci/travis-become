require 'active_record'
require 'yaml'

module Travis
  class Become
    class User < ActiveRecord::Base
      has_many :tokens
      has_many :permissions
      has_many :repositories, through: :permissions

      def data
        {
          id: id,
          name: name,
          login: login,
          email: email,
          gravatar_id: email ? Digest::MD5.hexdigest(email) : "",
          locale: locale,
          is_syncing: is_syncing,
          synced_at: format_date(synced_at),
          correct_scopes: correct_scopes?,
          created_at: format_date(created_at),
          channels: ["user-#{id}"],
          token: tokens.first.try(:token).to_s,
          vcs_type: vcs_type
        }
      end

      private

        def format_date(value)
          value.try(:strftime, "%Y-%m-%dT%T.%L%z")
        end

        def correct_scopes?
          missing = wanted_scopes - gh_scopes.to_a
          missing.empty?
        end

        def wanted_scopes
          Travis::Become.config.oauth2.scope.to_s.split(',').sort
        end

        def gh_scopes
          github_scopes && YAML.parse(github_scopes)
        end

        def repository_ids
          repositories.map { |r| r.id }
        end
    end
  end
end
