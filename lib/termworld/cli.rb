require "thor"

require "termworld/db/db"

module Termworld
  class CLI < Thor

    desc "start", "Start game client..."
    def start
      Signal.trap(:INT) {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      Process.daemon(true, false) # (nochdir, noclose)

      $db = DB.new
      3.times { |i| $db[:users].insert(name: "Sequel:#{i}", price: 0) }
      loop do
        $db[:users].update(price: Sequel[:price] + 1)
        break if @killed
        sleep 3
      end
    end
  end
end
