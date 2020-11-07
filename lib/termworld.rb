require "sequel"

require "termworld/config"
require "termworld/cli/cli"
require "termworld/daemon/daemon"
require "termworld/game/db"

require "ext/string"
require "termworld/utils/api_client"
require "termworld/utils/option_parser_wrapper"

module Termworld
  def self.start
    setup_termworld_directory
    $api_client = Utils::ApiClient.new
    $db = Sequel.sqlite(Termworld::DATABASE_NAME) if Daemon.new.alive?
    CLI.start
  end

  def self.setup_termworld_directory
    directory = Termworld::HOME_DIRECTORY_NAME
    Dir::chdir(Dir::home)
    Dir::mkdir(directory) unless Dir::exists?(directory)
    Dir::chdir(directory)
  end
end
