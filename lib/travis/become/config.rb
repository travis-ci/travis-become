require 'travis/config'

module Travis
  class Become
    class Config < Travis::Config
      define database: { adapter: 'postgresql', database: "travis_#{env}", encoding: 'unicode', min_messages: 'warning', pool: 25, reaping_frequency: 60, variables: { statement_timeout: 10000 } },
             redis: { pool: { size: 20 } },
             admins: [],
             encryption: { key: nil },
             api_endpoint: nil,
             web_endpoint: nil,
             web_endpoint_billing: nil,
             sentry: { dsn: nil },
             oauth2: { scope: "" }
    end
  end
end
