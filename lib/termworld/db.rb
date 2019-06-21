require "sequel"

require "termworld/models/user"

module Termworld
  class DB
    def initialize
      $db = Sequel.sqlite(Termworld::DATABASE_NAME)
    end
  end
end
