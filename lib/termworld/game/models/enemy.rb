module Termworld
  module Models
    class Enemy < Base
      self.model_name = "enemies"
      attr_reader :id, :name,
        :current_map_name, :positionx, :positiony,
        :level, :exp, :max_hp, :attack_power, :defensive_power,
        :attacking
      attr_accessor :hp

      class << self
        def create_table
          $db.create_table :enemies do
            primary_key :id
            String :name
            String :current_map_name
            Integer :positionx
            Integer :positiony
            Integer :level
            Integer :exp
            Integer :max_hp
            Integer :hp
            Integer :attack_power
            Integer :defensive_power
            Boolean :attacking
          end
        end
      end

      def initialize(params)
        @id = params[:id]
        @name = params[:name]
        @current_map_name = params[:current_map_name]
        @level = params[:level]
        @exp = params[:exp]
        @max_hp = params[:max_hp]
        @hp = params[:hp] ? params[:hp] : params[:max_hp]
        @attack_power = params[:attack_power]
        @defensive_power = params[:defensive_power]
        @attacking = false

        if (params[:positionx] && params[:positiony])
          @positionx = params[:positionx]
          @positiony = params[:positiony]
        else
          while !(@positionx && @positiony) do
            y = (0...(current_map.chip_numbers.size)).to_a.sample
            x = (0...(current_map.chip_numbers[y].size)).to_a.sample
            if current_map.get_chip(y: y, x: x).movable
              @positiony = y
              @positionx = x
            end
          end
        end
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
          max_hp: @max_hp,
          hp: @hp,
          attack_power: @attack_power,
          defensive_power: @defensive_power,
          attacking: @attacking,
        }
      end

      def validate
        @errors = []
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
        return false if chip.nil? || !chip.movable || chip.transition_map
        @positionx = supposed_position[:x]
        @positiony = supposed_position[:y]
        save_local
        true
      end

      def current_map
        @current_map ||= Object.const_get("Termworld::Resources::Maps::#{@current_map_name}").new
      end

      def attack
        @attacking = true
      end
    end
  end
end
