require "term_canvas"

module Termworld
  module Resources
    class Chip
      attr_reader :movable, :transition_map
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

      def empty?
        !!@empty
      end

      def data
        case @key
        when "--"
          @movable = false
          @empty = true
        when "00"
          @movable = true
          { background_color: {r: 300, g: 300, b: 300} }
        when "01"
          @movable = false
          { background_color: {r: 0, g: 0, b: 0} }
        when /^m[0-9]$/
          @movable = true
          @transition_map = true
          { background_color: {r: 1000, g: 1000, b: 1000} }
        when "player"
          { background_color: {r: 200, b: 200, g: 800} }
        when "other_player"
          { background_color: {r: 0, b: 700, g: 0} }
        end
      end
    end
  end
end
