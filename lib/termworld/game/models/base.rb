module Termworld
  module Models
    class Base
      class << self
        def model_name
          @model_name
        end

        def model_name=(value)
          @model_name = value
        end

        def all
          res = $api_client.call_auth(:get, "/#{model_name}")
          return [] if res.code != 200
          JSON.parse(res.body, {symbolize_names: true})[model_name.to_sym].map do |row|
            self.new(row)
          end
        end

        def all_local
          $db[model_name.to_sym].all.map do |row|
            self.new(row)
          end
        end

        def delete_local(id)
          $db[model_name.to_sym].where(id: id).delete
        end

        def delete_local_by_name(name)
          $db[model_name.to_sym].where(name: name).delete
        end
      end

      def initialize(params)
        params.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def model_name
        self.class.model_name
      end

      def attributes_without_id
        attributes.reject { |k, _| k == :id }
      end

      def create
        validate
        return false unless @errors.empty?
        res = $api_client.call_auth(:post, "/#{model_name}", attributes)
        return false if res.code != 201
        true
      end

      def save_local
        validate
        return false unless @errors.empty?
        if record = $db[model_name.to_sym].where(id: @id).first
          @created, @updated = false, true
          $db[model_name.to_sym].where(id: @id).update(attributes_without_id)
        else
          @created, @updated = true, false
          $db[model_name.to_sym].insert(attributes)
        end
      end

      def defeated
        self.class.delete_local(@id)
      end
    end
  end
end
