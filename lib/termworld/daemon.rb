module Termworld
  class Daemon
    attr_reader :error_message
    def initialize(status = nil)
      case status
      when :start
        @error_message = "Already running".bluen if alive?
      when :stop
        @error_message = "Not running".reden unless alive?
      end
    end

    def prepare
      delete_files
      [:INT, :TERM].each do |key|
        Signal.trap(key) {@killed = true}
      end
      DB.setup
      Process.setproctitle(Termworld::PROCESS_NAME)
    end

    def run
      Process.daemon(true, false) # (nochdir, noclose)
    end

    def alive?
      @killed.nil? && daemon_process_exists
    end

    def stop
      delete_files
      kill_daemon_process
    end

    def delete_files
      File.delete(Termworld::DATABASE_NAME) if File.exists?(Termworld::DATABASE_NAME)
    end

    private

      def kill_daemon_process
        `ps aux | grep #{Termworld::PROCESS_NAME} | grep -v grep | awk '{print $2}' | xargs kill`
      end

      def daemon_process_exists
        `ps aux | grep #{Termworld::PROCESS_NAME} | grep -v grep | wc -l`.delete(' ').to_i > 0
      end
  end
end
