module Termworld
  module Models
    class User
      attr_reader :id, :name, :created, :updated, :positionx, :positiony
      class << self
        def create_table
          $db.create_table :users do
            primary_key :id
            String :name
            String :current_map_name
            Integer :positionx
            Integer :positiony
          end
        end

        def all
          res = $api_client.call_auth(:get, '/users')
          return [] if res.code != 200
          JSON.parse(res.body, {symbolize_names: true})[:users].map do |user|
            self.new(user)
          end
        end

        def all_local
          $db[:users].all.map do |user|
            self.new(user)
          end
        end
      end

      def initialize(params)
        params.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def bind_local_by_name
        record = $db[:users].where(name: @name).first
        return false if record.nil?
        record.reject { |key, _| key == :name }.each { |key, value|
          instance_variable_set("@#{key}", value)
        }
        true
      end

      def create
        validate
        return false unless @errors.empty?
        res = $api_client.call_auth(:post, '/users', {name: @name})
        return false if res.code != 201
        true
      end
      def save_local
        validate
        return false unless @errors.empty?
        if record = $db[:users].where(id: @id).first
          @created, @updated = false, true
          $db[:users].where(id: @id).update(attributes_without_id)
        else
          @created, @updated = true, false
          $db[:users].insert(attributes)
        end
      end
      def delete_local(by: nil)
        if by == :id
          $db[:users].where(id: @id).delete
        elsif by == :name
          $db[:users].where(name: @name).delete
        end
      end

      def validate
        @errors = []
        if @name.nil? || @name.empty?
          @errors << "Name is required"
        elsif !@name.scan(/[^0-9a-z]+/i).empty?
          @errors << "Name must be only alphanumeric"
        end
      end

      def attributes
        {
          id: @id,
          name: @name,
          current_map_name: @current_map_name,
          positionx: @positionx,
          positiony: @positiony,
        }
      end
      def attributes_without_id
        attributes.reject { |k, _| k == :id }
      end

      def initialize_position
        @current_map_name = 'town'
        @positionx = 0
        @positiony = 0
      end

      def move(direction)
        supposed_position = {x: @positionx, y: @positiony}
        case direction
        when :up
          supposed_position[:y] -= 1
        when :down
          supposed_position[:y] += 1
        when :left
          supposed_position[:x] -= 1
        when :right
          supposed_position[:x] += 1
        else
          return false
        end
        return false if supposed_position.any? { |_, v| v < 0 }
        chip = current_map.get_chip(supposed_position)
        return false if chip.nil? || !chip.movable
        @positionx = supposed_position[:x]
        @positiony = supposed_position[:y]
        save_local
        true
      end

      def current_map
        @current_map ||= Object.const_get("Termworld::Resources::Maps::#{@current_map_name.capitalize}").new
        @current_map
      end
    end
  end
end
