module Termworld
  class Credential
    class << self
      def logged_in?(with_messages = false)
        if !File.exists?(Termworld::CREDENTIAL_FILE_NAME)
          puts Utils::Color.reden "Login required" if with_messages
          return false
        end
        email, token = self.get_credential
        File.open(Termworld::CREDENTIAL_FILE_NAME) do |file|
          email, token = file.read.split("\n")
        end
        res = $api_client.call(:post, '/login', {email: email, token: token})
        if res.code != 200
          puts Utils::Color.reden "Wrong credential\nPlease login again" if with_messages
          return false
        end
        true
      end

      def get_credential
        email, token = nil
        begin
          File.open(Termworld::CREDENTIAL_FILE_NAME) do |file|
            email, token = file.read.split("\n")
          end
        rescue
          return [nil, nil]
        end
        [email, token]
      end
    end
  end
end
