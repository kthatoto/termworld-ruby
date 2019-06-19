module Termworld
  module Commands
    class User < Thor

      desc "create", "Create task."
      def create(*options)
        pp options
        puts "Create!!"
      end
    end
  end
end
