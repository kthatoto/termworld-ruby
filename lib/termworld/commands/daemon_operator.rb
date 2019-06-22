require "termworld/daemon"

module Termworld
  module Commands
    class DaemonOperator
      class << self
        def start
          daemon = Daemon.new(:start)
          return puts daemon.error_message if daemon.error_message
          daemon.prepare
          puts Utils::Color.greenen "Started!"
          daemon.run

          loop do
            break unless daemon.alive?
            `echo #{rand} >> daemon.log`
            sleep 1
          end
          daemon.stop
        end

        def stop
          daemon = Daemon.new(:stop)
          if daemon.error_message
            daemon.delete_files
            puts daemon.error_message
            return
          end
          daemon.stop
          puts Utils::Color.greenen "Stopped!"
        end

        def status
          daemon = Daemon.new(:status)
          return puts daemon.error_message if daemon.error_message
          if daemon.alive?
            puts Utils::Color.bluen "Running!"
          else
            puts Utils::Color.bluen "Not running."
          end
        end
      end
    end
  end
end
