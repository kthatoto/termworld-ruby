require "term_canvas"

require "termworld/resources/maps/town"

module Termworld
  module Terminal
    class Controller
      def initialize(user)
        @user = user
      end

      def run
        # status = TermCanvas.new()
        field = TermCanvas.new(x: 0, y: 0, w: 50, h: 30)
        loop do
          key = TermCanvas.gets
          case key
          when ?q
            break
          end

          field.clear
          field.rect(
            Rect
          )
        end
      end
    end
  end
end
