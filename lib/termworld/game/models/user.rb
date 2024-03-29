module Termworld
  module Models
    class User < Base
      self.model_name = "users"
      attr_reader :id, :name, :created, :updated,
        :current_map_name, :positionx, :positiony,
        :level, :exp, :next_level_exp, :max_hp, :attack_power, :defensive_power
      attr_accessor :hp, :attacking
      class << self
        def create_table
          $db.create_table :users do
            primary_key :id
            String :name
            String :current_map_name
            Integer :positionx
            Integer :positiony
            Integer :level
            Integer :exp
            Integer :next_level_exp
            Integer :max_hp
            Integer :hp
            Integer :attack_power
            Integer :defensive_power
          end
        end
      end

      def initialize_status
        @current_map_name = 'Field'
        @positionx = 20
        @positiony = 20
        @hp = @max_hp
      end

      def attributes
        {
          id: @id,
          name: @name,
          current_map_name: @current_map_name,
          positionx: @positionx,
          positiony: @positiony,
          level: @level,
          exp: @exp,
          next_level_exp: @next_level_exp,
          max_hp: @max_hp,
          hp: @hp,
          attack_power: @attack_power,
          defensive_power: @defensive_power,
        }
      end

      def bind_local_by_name
        record = $db[:users].where(name: @name).first
        return false if record.nil?
        record.reject { |key, _| key == :name }.each { |key, value|
          instance_variable_set("@#{key}", value)
        }
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
        chip = current_map.get_chip(**supposed_position)
        return false if chip.nil? || !chip.movable
        if chip.transition_map
          @current_map_name = current_map.class::TRANSITION_MAPS[chip.key.to_sym]
          load_map
          @positiony, @positionx = @current_map.find_transition_position(chip.key)
        else
          @positionx = supposed_position[:x]
          @positiony = supposed_position[:y]
        end
        save_local
        true
      end

      def earn_exp value
        res = $api_client.call_auth(:patch, "/users/#{@name}/earn_exp", { exp: value })
        res = JSON.parse(res.body, {symbolize_names: true})
        bind_server_user_to_self(res[:user])
        @hp = @max_hp
        save_local
        res
      end

      def current_map
        @current_map ||= Object.const_get("Termworld::Resources::Maps::#{@current_map_name}").new
      end

      def attack
        @attacking = true
      end

      private

        def load_map
          @current_map = Object.const_get("Termworld::Resources::Maps::#{@current_map_name}").new
        end

        def bind_server_user_to_self(server_user)
          @exp = server_user[:exp]
          @level = server_user[:level]
          @max_hp = server_user[:max_hp]
          @attack_power = server_user[:attack_power]
          @defensive_power = server_user[:defensive_power]
          @next_level_exp = server_user[:next_level_exp]
        end
    end
  end
end
