require "term_canvas"

require "termworld/game/resources/chip"
require "termworld/game/resources/maps/town"

module Termworld
  module Terminal
    class Controller
      def initialize(user)
        @user = user
      end

      def run
        field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width, h: TermCanvas.height)

        map = Resources::Maps::Town.new
        loop do
          @user.bind_local_by_name
          users = Models::User.all_local.reject { |user| user.name == @user.name }

          break if handle_keys == :break
          field.clear

          height = field.height
          width = field.width / 2 - 1
          height.times do |y|
            width.times do |x|
              abs_position = {
                x: @user.positionx - (width / 2) + x,
                y: @user.positiony - (height / 2) + y,
              }
              user = users.find { |u|
                u.positionx == abs_position[:x] && u.positiony == abs_position[:y]
              }
              if user
                player_chip = Resources::Chip.new(x: x * 2 + 1, y: y, key: "pl")
                field.rect(player_chip.rect)
                next
              end
              next if abs_position.any? { |_, v| v < 0 }
              next if (chip = map.get_chip(abs_position)).nil?
              field.rect(chip.rect.position_override(x: x * 2 + 1, y: y))
            end
          end

          player_chip = Resources::Chip.new(x: field.centerx, y: field.centery, key: "pl")
          field.rect(player_chip.rect)

          field.update
          sleep 0.05
        end
        TermCanvas.close
      end

      private

        def handle_keys
          key = TermCanvas.gets
          case key
          when ?q
            return :break
          when ?h
            @user.move(:left)
          when ?j
            @user.move(:down)
          when ?k
            @user.move(:up)
          when ?l
            @user.move(:right)
          end
        end
    end
  end
end
