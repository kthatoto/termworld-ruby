require "thor"

require "termworld/db/db"
require "termworld/daemon"
require "termworld/commands/user"

module Termworld
  class CLI < Thor

    desc "start", "Start game client."
    def start
      daemon = Daemon.new
      daemon.prepare

      loop do
        daemon.check_alive
        break if $killed
        sleep 1
      end
      daemon.stop
    end

    desc "stop", "Stop game client"
    def stop
      daemon = Daemon.new
      daemon.stop
    end

    desc "user [COMMAND] <options>", "User actions"
    subcommand "user", Commands::User

    def method_missing(method, *arg, &block)
      _method = method.to_s.split(?:)
      puts "Command:#{_method[0]}"
      puts "Name:#{_method[1]}"
      pp arg
    end
  end
end
