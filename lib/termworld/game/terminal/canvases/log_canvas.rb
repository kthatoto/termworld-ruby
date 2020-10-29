module Termworld
  module Terminal
    class LogCanvas < Termworld::Canvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          y: Controller::META_CANVAS_HEIGHT,
          w: Controller::META_CANVAS_WIDTH,
          h: TermCanvas.height - Controller::META_CANVAS_HEIGHT,
        )
      end

      def draw
        @canvas.background(BACKGROUND_COLOR)
        text(x: 0, y: 0, body: "—" * (@canvas.width - 1))
      end
    end
  end
end
