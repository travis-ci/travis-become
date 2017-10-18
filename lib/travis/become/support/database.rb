module Travis
  class Become
    class Database
      def self.connect
        config = Travis::Become.config.database.to_h

        ActiveRecord::Base.default_timezone = :utc
        ActiveRecord::Base.establish_connection(config)
      end
    end
  end
end
