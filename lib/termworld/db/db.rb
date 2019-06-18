require "termworld/db/user"

module Termworld
  class DB
    def initialize
      $db = Sequel.sqlite('./termworld.db')
      User.new
    end
  end
end
