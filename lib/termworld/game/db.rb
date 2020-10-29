require "termworld/game/models/base"

require "termworld/game/models/user"
require "termworld/game/models/enemy"

module Termworld
  class DB
    class << self
      def setup
        $db ||= Sequel.sqlite(Termworld::DATABASE_NAME)
        Models::User.create_table
        Models::Enemy.create_table
      end
    end
  end
end
