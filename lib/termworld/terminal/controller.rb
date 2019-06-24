require "term_canvas"

require "termworld/resources/maps/town"

module Termworld
  module Terminal
    class Controller
      def initialize(user)
        @user = user
      end

      def run
        field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width, h: TermCanvas.height)

        loop do
          key = TermCanvas.gets
          case key
          when ?q
            break
          end
          field.clear

          # background = TermCanvas::Rect.new(
          #   x: 0, y: 0, width: 10, height: 10,
          #   background_color: {r: 200, b: 200, g: 800},
          # )
          # field.rect(background)
          player = TermCanvas::Rect.new(
            x: field.centerx, y: field.centery, width: 2, height: 1,
            background_color: {r: 200, b: 200, g: 200},
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
