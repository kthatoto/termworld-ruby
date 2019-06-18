require "thor"

require "termworld/db/db"

module Termworld
  class CLI < Thor

    desc "start", "Start game client."
    def start
      Signal.trap(:INT) {@killed = true}
      Signal.trap(:TERM) {@killed = true}

      DB.new
      3.times { |i| $db[:users].insert(name: "Sequel:#{i}", price: 0) }

      puts "Started!"
      Process.daemon(true, false) # (nochdir, noclose)
      loop do
        $db[:users].update(price: Sequel[:price] + 1)
        break if @killed
        sleep 3
      end
      DB.stop
    end

    desc "stop", "Stop game client."
    def stop
    end
  end
end
