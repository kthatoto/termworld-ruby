require "term_canvas"

module Termworld
  module Resources
    class Chip
      def initialize(y: nil, x: nil, key:)
        @y = y
        @x = x
        @key = key
      end

      def background_color
        case @key
        when "00"
          return {r: 300, g: 300, b: 300}
        when "01"
          return {r: 0, g: 0, b: 0}
        when "pl"
          return {r: 200, b: 200, g: 800}
        end
      end

      def rect
        TermCanvas::Rect.new(
          x: @x, y: @y, width: 2, height: 1,
          background_color: background_color,
        )
      end
    end
  end
end
