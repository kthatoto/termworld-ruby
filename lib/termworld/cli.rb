require "thor"

require "termworld/db/db"
require "termworld/daemon"

module Termworld
  class CLI < Thor

    desc "start", "Start game client."
    def start
      daemon = Daemon.new
      daemon.prepare

      loop do
        daemon.check_alive
        break if @killed
        sleep 1
      end
    end

    desc "stop", "Stop game client."
    def stop
      daemon = Daemon.new
      daemon.stop
    end
  end
end
