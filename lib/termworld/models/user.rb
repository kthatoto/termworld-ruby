module Termworld
  module Model
    class User
      attr_reader :id, :name
      class << self
        def create_table
          $db.create_table :users do
            primary_key :id
            String :name
          end
        end

        def all
          res = $api_client.call_auth(:get, '/users')
          return [] if res.code != 200
          JSON.parse(res.body)['users'].map do |user|
            self.new({id: user['id'], name: user['name']})
          end
        end
      end

      def initialize(params)
        @id = params[:id]
        @name = params[:name]
      end

      def save
        validate
        return false unless @errors.empty?
        res = $api_client.call_auth(:post, '/users', {name: @name})
        return false if res.code != 201
        true
      end
      def validate
        @errors = []
        if @name.nil? || @name.empty?
          @errors << "Name is required"
        elsif !@name.scan(/[^0-9a-z]+/i).empty?
          @errors << "Name must be only alphanumeric"
        end
      end
    end
  end
end
