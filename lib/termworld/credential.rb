module Termworld
  class Credential
    attr_reader :error_message
    def logged_in?
      if !File.exists?(Termworld::CREDENTIAL_FILE_NAME)
        @error_message = Utils::Color.reden "Login required"
        return false
      end
      email, token = Credential.get_credential
      File.open(Termworld::CREDENTIAL_FILE_NAME) do |file|
        email, token = file.read.split("\n")
      end
      res = $api_client.call(:post, '/login', {email: email, token: token})
      if res.code != 200
        @error_message = Utils::Color.reden "Wrong credential\nPlease login again"
        return false
      end
      true
    end
    class << self
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
