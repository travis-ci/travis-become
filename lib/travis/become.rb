require 'travis/become/config'

module Travis
  class Become
    def self.config
      @config ||= Config.load
    end
  end
end
