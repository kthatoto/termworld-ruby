module Termworld
  module Commands
    class Account
      class << self
        def login
          credential = Credential.new
          return puts "Already logged in".bluen if credential.logged_in?
          print "email: "
          email = $stdin.gets.chomp
          res = $api_client.call(:post, '/token', {email: email})
          return puts "Invalid email".reden if res.code != 200
          puts "Sent token to your email, please input below".greenen
          print "token: "
          token = $stdin.gets.chomp
          res = $api_client.call(:post, '/login', {email: email, token: token})
          return puts "Invalid token".reden if res.code != 200
          File.write(Termworld::CREDENTIAL_FILE_NAME, "#{email}\n#{token}")
          puts "Login successed!".greenen
        end

        def logout
          credential = Credential.new
          return puts "Not logged in".reden unless credential.logged_in?
          email, token = Credential.get_credential
          res = $api_client.call(:post, '/logout', {email: email, token: token})
          return puts "Logout failed".reden if res.code != 200
          daemon = Daemon.new(:logout)
          daemon.stop if daemon.alive?
          File.delete(Termworld::CREDENTIAL_FILE_NAME) if File.exists?(Termworld::CREDENTIAL_FILE_NAME)
          puts "Logout successed!".greenen
        end
      end
    end
  end
end
