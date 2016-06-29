require 'travis/config'

module Travis
  class Become
    class Config < Travis::Config
      define redis: { pool: { size: 20 } },
             admins: [],
             encryption: { key: nil },
             api_endpoint: nil,
             web_endpoint: nil,
             sentry: { dsn: nil }
    end
  end
end
