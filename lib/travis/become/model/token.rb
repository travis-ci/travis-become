require 'active_record'

module Travis
  class Become
    class Token < ActiveRecord::Base
      belongs_to :user

      # token field used to use EncryptedColumn
      # but encryption is currently disabled everywhere
      # if we consider re-introducing EncryptedColumn,
      # please make sure to re-introduce it here <3
    end
  end
end
