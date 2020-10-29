module Termworld
  module Terminal
    class MetaCanvas < Termworld::Canvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          y: 0,
          w: Controller::META_CANVAS_WIDTH,
          h: Controller::META_CANVAS_HEIGHT,
        )
      end

      def draw
        @canvas.background(BACKGROUND_COLOR)
        text(x: 1, y: 1, body:   "current map: #{@store.map.name}")
        text(x: 1, y: 3, body:   "   position: { x: #{@store.user.positionx}, y: #{@store.user.positiony} }")

        text(x: 1, y: 5, body:   "    players:")
        y = 7
        if @store.users.size == 0
          text(x: 1, y: y, body: "      -----")
        else
        end
      end
    end
  end
end
