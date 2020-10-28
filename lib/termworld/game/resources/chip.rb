require "term_canvas"

module Termworld
  module Resources
    class Chip
      attr_reader :movable
      def initialize(y: nil, x: nil, key:)
        @y = y
        @x = x
        @key = key
        data
      end

      def rect
        TermCanvas::Rect.new(
          x: @x, y: @y, width: 2, height: 1,
          background_color: data[:background_color],
        )
      end

      def data
        case @key
        when "00"
          @movable = true
          {
            background_color: {r: 300, g: 300, b: 300},
          }
        when "01"
          @movable = false
          {
            background_color: {r: 0, g: 0, b: 0},
          }
        when "pl"
          {
            background_color: {r: 200, b: 200, g: 800},
          }
        end
      end
    end
  end
end
