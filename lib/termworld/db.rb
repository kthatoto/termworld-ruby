require "termworld/models/user"

module Termworld
  class DB
    class << self
      def setup
        $db ||= Sequel.sqlite(Termworld::DATABASE_NAME)
        Models::User.create_table
      end
    end
  end
end
