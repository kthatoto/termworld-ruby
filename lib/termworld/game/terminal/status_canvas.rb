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

      def draw
        @canvas.rect(
          TermCanvas::Rect.new(
            x: 0, y: 0, width: @canvas.width - 1, height: @canvas.height,
            background_color: {r: 300, g: 300, b: 400},
          )
        )
      end
    end
  end
end
