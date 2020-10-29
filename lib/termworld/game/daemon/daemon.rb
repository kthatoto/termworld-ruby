module Termworld
  module Game
    class Daemon
      def work
        @enemies = Models::Enemy.all_local

        if (cool_times[:field] -= 1) <= 0 && @enemies.select {|e| e.current_map_name == "Field"}.size < 3
          level = (2..4).to_a.sample
          enemy = Models::Enemy.new(
            id: @enemies.map(&:id).max.to_i + 1,
            name: "Rat",
            current_map_name: "Field",
            level: level,
            exp: level * 1,
            max_hp: level * 1,
            attack_power: level * 1,
            defensive_power: level * 1,
          )
          enemy.save_local
          cool_times[:field] = 3
          @enemies << enemy
        end

        if (cool_times[:cave] -= 1) <= 0 && @enemies.select {|e| e.current_map_name == "Cave"}.size < 1
          level = (4..7).to_a.sample
          enemy = Models::Enemy.new(
            id: @enemies.map(&:id).max.to_i + 1,
            name: "Cave Bat",
            current_map_name: "Cave",
            level: level,
            exp: level * 1.8,
            max_hp: level * 2,
            attack_power: level * 1.2,
            defensive_power: level * 2,
          )
          enemy.save_local
          cool_times[:cave] = 8
          @enemies << enemy
        end

        @enemies.each do |enemy|
          direction = [:up, :down, :left, :right].sample
          enemy.move(direction)
        end
      end

      def cool_times
        @cool_times ||= {
          field: 0,
          cave: 0,
        }
      end
    end
  end
end
