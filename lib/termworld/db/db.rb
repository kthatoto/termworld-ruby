require "sequel"

require "termworld/db/user"

module Termworld
  class DB
    def initialize
      $db = Sequel.sqlite('./termworld.db')
      User.new
    end

    def self.stop
      `rm termworld.db`
    end
  end
end
