module Termworld
  module Terminal
    class FieldCanvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: 0, y: 0,
          w: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          h: TermCanvas.height - Controller::STATUS_CANVAS_HEIGHT,
        )
      end

      def clear
        @canvas.clear
      end

      def update
        @canvas.update
      end

      def draw
        height = @canvas.height
        width = @canvas.width / 2 - 1

        height.times do |y|
          width.times do |x|
            abs_position = {
              x: @store.user.positionx - (width / 2) + x,
              y: @store.user.positiony - (height / 2) + y,
            }
            user = @store.users.find { |u|
              u.positionx == abs_position[:x] && u.positiony == abs_position[:y]
            }
            if user
              player_chip = Resources::Chip.new(x: x * 2 + 1, y: y, key: "pl")
              @canvas.rect(player_chip.rect)
              next
            end
            next if abs_position.any? { |_, v| v < 0 }
            next if (chip = @store.map.get_chip(abs_position)).nil?
            @canvas.rect(chip.rect.position_override(x: x * 2 + 1, y: y))
          end
        end

        player_chip = Resources::Chip.new(x: @canvas.centerx, y: @canvas.centery, key: "pl")
        @canvas.rect(player_chip.rect)
      end
    end
  end
end
