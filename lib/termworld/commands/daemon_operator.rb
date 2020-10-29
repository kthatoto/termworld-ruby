require "termworld/game/daemon/daemon"

module Termworld
  module Commands
    class DaemonOperator
      class << self
        def start
          credential = Credential.new
          return puts credential.error_message unless credential.logged_in?
          daemon = Daemon.new(:start)
          return puts daemon.error_message if daemon.error_message
          daemon.prepare
          puts "Started!".greenen
          # daemon.run

          game_daemon = Termworld::Game::Daemon.new
          loop do
            break unless daemon.alive?
            game_daemon.work
            sleep 1
          end
          daemon.stop
        end

        def stop
          credential = Credential.new
          daemon = Daemon.new(:stop)
          unless credential.logged_in?
            daemon.stop
            return puts credential.error_message
          end
          if daemon.error_message
            daemon.delete_files
            return puts daemon.error_message
          end
          daemon.stop
          puts "Stopped!".greenen
        end

        def status
          credential = Credential.new
          return puts credential.error_message unless credential.logged_in?
          daemon = Daemon.new(:status)
          return puts daemon.error_message if daemon.error_message
          if daemon.alive?
            puts "Running!".bluen
          else
            puts "Not running.".bluen
          end
        end
      end
    end
  end
end
