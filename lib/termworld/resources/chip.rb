require "term_canvas"

module Termworld
  module Resources
    class Chip
      def initialize(y:, x:, number:)
        @y = y
        @x = x
        @number = number.to_i
      end

      def background_color
        case @number
        when 0
          return {r: 300, g: 300, b: 300}
        when 1
          return {r: 0, g: 0, b: 0}
        end
      end

      def rect
        TermCanvas::Rect.new(
          x: @x * 2, y: @y, width: 2, height: 1,
          background_color: background_color,
        )
      end
    end
  end
end
