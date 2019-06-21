require "termworld/daemon"

module Termworld
  module Commands
    class DaemonOperator
      class << self
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

        def stop
          daemon = Daemon.new(:stop)
          if daemon.error
            daemon.delete_files
            daemon.handle_error
            return
          end
          daemon.stop
        end

        def status
          daemon = Daemon.new(:status)
          return daemon.handle_error if daemon.error
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
