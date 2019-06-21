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
    end
  end
end
