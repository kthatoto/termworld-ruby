module Termworld
  module Commands
    class Account
      class << self
        def login
          return puts Utils::Color.reden "Already logged in" if Credential.logged_in?
          print "email: "
          email = $stdin.gets.chomp
          res = $api_client.call(:post, '/token', {email: email})
          return puts Utils::Color.reden "Invalid email" if res.code != 200
          puts Utils::Color.greenen "Sent token to your email, please input below"
          print "token: "
          token = $stdin.gets.chomp
          res = $api_client.call(:post, '/login', {email: email, token: token})
          return puts Utils::Color.reden "Invalid token" if res.code != 200
          File.write(Termworld::CREDENTIAL_FILE_NAME, "#{email}\n#{token}")
          puts Utils::Color.greenen "Login successed!"
        end

        def logout
          return puts Utils::Color.reden "Not logged in" unless Credential.logged_in?
          email, token = Credential.get_credential
          res = $api_client.call(:post, '/logout', {email: email, token: token})
          return puts Utils::Color.reden "Logout failed" if res.code != 200
          daemon = Daemon.new(:logout)
          daemon.stop if daemon.alive?
          File.delete(Termworld::CREDENTIAL_FILE_NAME) if File.exists?(Termworld::CREDENTIAL_FILE_NAME)
          puts Utils::Color.greenen "Logout successed!"
        end
      end
    end
  end
end
