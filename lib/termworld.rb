require "termworld/cli"
require "termworld/constants/config"

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
