require 'active_record'
require 'travis/become/encrypted_column'

module Travis
  class Become
    class Token < ActiveRecord::Base
      serialize :token, Travis::Become::EncryptedColumn.new(disable: true)
    end
  end
end
