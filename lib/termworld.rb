require "termworld/cli"
require "termworld/config"
require "termworld/utils"

module Termworld
  def self.start
    setup_termworld_directory
    CLI.start
  end

  def self.setup_termworld_directory
    directory = Termworld::HOME_DIRECTORY_NAME
    Dir::chdir(Dir::home)
    Dir::mkdir(directory) unless Dir::exists?(directory)
    Dir::chdir(directory)
  end
end
