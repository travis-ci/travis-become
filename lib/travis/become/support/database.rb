module Travis
  class Become
    class Database < Struct.new(:const, :config, :logger)
      class << self
        def instances
          @instances ||= {}
        end

        def connect(const, config)
          instances[const] ||= new(const, config).tap do |instance|
            instance.connect
          end
        end
      end

      def connect
        const.default_timezone = :utc
        const.establish_connection(config.to_h)
      end
    end
  end
end
