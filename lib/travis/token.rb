require 'active_record'

module Travis
  class Token < ActiveRecord::Base
    serialize :token, Travis::EncryptedColumn.new(disable: true)
  end
end
