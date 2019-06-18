require "thor"
require "sequel"

require "termworld/db/db"
require "termworld/cli"

module Termworld
  def self.start
    DB.new
    CLI.start
  end
end
