module Termworld
  class Daemon

    def prepare
      Signal.trap(:INT) {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      DB.new
      Process.setproctitle("termworld_daemon")
      File.write(Termworld::DAEMON_ALIVE_FILE_NAME, nil)
      puts "Started!"
      Process.daemon(true, false) # (nochdir, noclose)
    end

    def check_alive
      stop if !File.exists?(Termworld::DAEMON_ALIVE_FILE_NAME)
    end

    def stop
      `ps aux | grep termworld_daemon | grep -v grep | awk '{print $2}' | xargs kill`
      DB.stop
      puts "Stopped!"
    end
  end
end
