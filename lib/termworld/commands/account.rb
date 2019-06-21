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
        end
      end
    end
  end
end
