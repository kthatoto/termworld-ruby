module Termworld
  class DB
    def initialize
      $db = Sequel.sqlite
      User.new
    end
  end
end
