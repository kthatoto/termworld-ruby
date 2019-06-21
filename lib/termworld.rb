require "termworld/config"
require "termworld/utils/color"
require "termworld/utils/api_client"
require "termworld/cli"

module Termworld
  def self.start
    setup_termworld_directory
    $api_client = Utils::ApiClient.new
    CLI.start
  end

  def self.setup_termworld_directory
    directory = Termworld::HOME_DIRECTORY_NAME
    Dir::chdir(Dir::home)
    Dir::mkdir(directory) unless Dir::exists?(directory)
    Dir::chdir(directory)
  end
end
