module Termworld
  class CLI < Thor

    desc "start", "Start game client..."
    def start
      puts :starting
    end
  end
end
