require "term_canvas"

require "termworld/resources/maps/town"

module Termworld
  module Terminal
    class Controller
      def initialize(user)
        @user = user
      end

      def run
        require 'pry'
        binding.pry
        field = TermCanvas::Canvas.new(x: 0, y: 0, w: 10, h: 10)

        loop do
          key = TermCanvas.gets
          case key
          when ?q
            break
          end
          field.clear

          player = TermCanvas::Rect.new(
            x: field.centerx, y: field.centery, width: 2, height: 1,
            background_color: {r: 200, b: 200, g: 700},
          )
          field.rect(player)
          background = TermCanvas::Rect.new(
            x: 0, y: 0, width: 10, height: 10,
            background_color: {r: 200, b: 200, g: 800},
          )
          field.rect(background)
          field.update
          sleep 1
        end
        TermCanvas.close
      end
    end
  end
end
