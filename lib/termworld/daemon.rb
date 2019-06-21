module Termworld
  class Daemon
    attr_reader :error
    def initialize(status)
      case status
      when :start
        @error = :already_running if alive?
      when :stop
        @error = :not_running unless alive?
      end
    end

    def run
      delete_files
      [:INT, :TERM].each do |key|
        Signal.trap(key) {@killed = true}
      end
      DB.new
      Process.setproctitle(Termworld::PROCESS_NAME)
      File.write(Termworld::DAEMON_FILE_NAME, nil)
      puts Utils::Color.greenen "Started!"
      Process.daemon(true, false) # (nochdir, noclose)
    end

    def alive?
      @killed.nil? && daemon_file_exists && daemon_process_exists
    end

    def stop
      kill_daemon_process
      delete_files
      puts Utils::Color.greenen "Stopped!"
    end

    def handle_error
      case @error
      when :already_running
        puts Utils::Color.reden "Already running"
      when :not_running
        puts Utils::Color.reden "Not running"
      end
    end

    def delete_files
      File.delete(Termworld::DAEMON_FILE_NAME) if File.exists?(Termworld::DAEMON_FILE_NAME)
      File.delete(Termworld::DATABASE_NAME) if File.exists?(Termworld::DATABASE_NAME)
    end

    private

      def kill_daemon_process
        `ps aux | grep #{Termworld::PROCESS_NAME} | grep -v grep | awk '{print $2}' | xargs kill`
      end

      def daemon_file_exists
        File.exists?(Termworld::DAEMON_FILE_NAME)
      end

      def daemon_process_exists
        `ps aux | grep #{Termworld::PROCESS_NAME} | grep -v grep | wc -l`.delete(' ').to_i > 0
      end
  end
end
