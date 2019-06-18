module Termworld
  class CLI < Thor

    desc "start", "Start game client..."
    def start
      Signal.trap(:INT) {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      puts Dir.pwd
      Process.daemon(true, true)
      loop do
        break if @killed
      end
    end
  end
end
