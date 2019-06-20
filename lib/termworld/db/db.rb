require "sequel"

require "termworld/db/user"

module Termworld
  class DB
    def initialize
      $db = Sequel.sqlite(Termworld::DATABASE_NAME)
      User.new
    end
  end
end
