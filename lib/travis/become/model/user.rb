require 'active_record'

module Travis
  class Become
    class User < ActiveRecord::Base
      has_many :tokens
    end
  end
end
