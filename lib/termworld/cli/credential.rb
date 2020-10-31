module Termworld
  class Credential
    attr_reader :error_message

    def logged_in?
      if !File.exists?(Termworld::CREDENTIAL_FILE_NAME)
        @error_message = "Login required".reden
        return false
      end
      email, token = Credential.get_credential
      res = $api_client.call(:post, '/login', {email: email, token: token})
      if res.code != 200
        @error_message = "Wrong credential\nPlease login again".reden
        return false
      end
      true
    end

    class << self
      def get_credential
        email, token = nil
        File.open(Termworld::CREDENTIAL_FILE_NAME) do |file|
          email, token = file.read.split("\n")
        end
        [email, token]
      rescue
        [nil, nil]
      end
    end
  end
end
