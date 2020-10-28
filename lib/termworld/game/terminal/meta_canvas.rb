module Termworld
  module Terminal
    class MetaCanvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          y: 0,
          w: Controller::META_CANVAS_WIDTH,
          h: TermCanvas.height,
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
        # @canvas.text(
        #   TermCanvas::Rect.new(
        #     x: 1, y: 1, body: "current map: #{}",
        #     background_color: {}
        #   )
        # )
      end
    end
  end
end
