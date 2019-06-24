require "term_canvas"

require "termworld/resources/chip"
require "termworld/resources/maps/town"

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
          key = TermCanvas.gets
          case key
          when ?q
            break
          end
          field.clear

          height = field.height
          width = field.width / 2
          height.times do |y|
            width.times do |x|
              abs_position = {
                x: @user.positionx - (width / 2) + x,
                y: @user.positiony - (height / 2) + y,
              }
              next if abs_position.any? { |_, v| v < 0 }
              next if (chip = map.get_chip(abs_position)).nil?
              field.rect(chip.rect)
            end
          end

          player = TermCanvas::Rect.new(
            x: field.centerx, y: field.centery, width: 2, height: 1,
            background_color: {r: 200, b: 200, g: 800},
          )
          field.rect(player)

          field.update
          sleep 1
        end
        TermCanvas.close
      end
    end
  end
end
