require 'active_record'

module Travis
  class Become
    class Permission < ActiveRecord::Base
      belongs_to :user
      belongs_to :repository
    end
  end
end
