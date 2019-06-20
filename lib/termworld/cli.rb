require "thor"

require "termworld/db/db"
require "termworld/daemon"
require "termworld/commands/user"

module Termworld
  class CLI < Thor

    desc "start", "Start game client"
    def start
      daemon = Daemon.new(:start)
      return daemon.handle_error if daemon.error
      daemon.run

      loop do
        break unless daemon.alive?
        `echo #{rand} >> daemon.log`
        sleep 1
      end
      daemon.stop
    end

    desc "stop", "Stop game client"
    def stop
      daemon = Daemon.new(:stop)
      if daemon.error
        daemon.delete_files
        daemon.handle_error
        return
      end
      daemon.stop
    end

    desc "status", "Check status"
    def status
      daemon = Daemon.new(:status)
      if daemon.alive?
        puts ColorUtil.bluen "Running!"
      else
        puts ColorUtil.bluen "Not running."
      end
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
