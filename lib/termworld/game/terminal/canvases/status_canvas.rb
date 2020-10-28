module Termworld
  module Terminal
    class StatusCanvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: 0,
          y: TermCanvas.height - Controller::STATUS_CANVAS_HEIGHT,
          w: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          h: Controller::STATUS_CANVAS_HEIGHT,
        )
      end

      def clear
        @canvas.clear
      end

      def update
        @canvas.update
      end

      BACKGROUND_COLOR = {r:  300, g:  300, b:  400}
      FOREGROUND_COLOR = {r: 1000, g: 1000, b: 1000}
      def draw
        @canvas.background(BACKGROUND_COLOR)
      end
    end
  end
end
