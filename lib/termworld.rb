require "thor"
require "sequel"

require "termworld/constants/version"
require "termworld/db/db"
require "termworld/cli"

module Termworld
  def self.start
    CLI.start
  end
end
