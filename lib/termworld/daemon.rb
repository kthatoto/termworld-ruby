module Termworld
  class Daemon
    def initialize
    end

    def prepare
      Signal.trap(:INT) {$killed = true}
      Signal.trap(:TERM) {$killed = true}
      DB.new
      Process.setproctitle("termworld_daemon")
      File.write(Termworld::DAEMON_ALIVE_FILE_NAME, nil)
      puts "Started!"
      Process.daemon(true, false) # (nochdir, noclose)
    end

    def alive?
      !File.exists?(Termworld::DAEMON_ALIVE_FILE_NAME)
    end

    def stop
      `ps aux | grep termworld_daemon | grep -v grep | awk '{print $2}' | xargs kill`
      `rm #{Termworld::DAEMON_ALIVE_FILE_NAME}`
      DB.stop
      puts "Stopped!"
    end
  end
end
