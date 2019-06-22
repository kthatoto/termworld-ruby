require "httpclient"

module Termworld
  module Utils
    class ApiClient

      def initialize
        @client = HTTPClient.new
      end

      def call(method, url, params = nil)
        if method == :get
          res = @client.get(Termworld::API_ENDPOINT + url, query: params)
        else
          res = @client.send(method, Termworld::API_ENDPOINT + url, body: params)
        end
        res
      end

      def call_auth(method, url, params = nil)
        email, token = Credential.get_credential
        headers = {
          'X-Termworld-Email': email,
          'X-Termworld-Token': token,
        }
        if method == :get
          res = @client.get(Termworld::API_ENDPOINT + url, query: params, header: headers)
        else
          res = @client.send(method, Termworld::API_ENDPOINT + url, body: params, header: headers)
        end
        res
      end
    end
  end
end
