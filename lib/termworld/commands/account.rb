module Termworld
  module Commands
    class Account
      class << self
        def login
          if Credential.logged_in?
            puts Utils::Color.reden "Already logged in"
            return
          end
          print "email: "
          ::Kernel.gets.chomp
        end

        def logout
        end
      end
    end
  end
end
