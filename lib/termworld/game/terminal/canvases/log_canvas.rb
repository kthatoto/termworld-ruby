module Termworld
  module Terminal
    class LogCanvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          y: Controller::META_CANVAS_HEIGHT,
          w: Controller::META_CANVAS_WIDTH,
          h: TermCanvas.height - Controller::META_CANVAS_HEIGHT,
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
        text(x: 0, y: 0, body: "—" * (@canvas.width - 1))
      end

      private

        def text(x:, y:, body:, bg_color: BACKGROUND_COLOR, fg_color: FOREGROUND_COLOR)
          @canvas.text(
            TermCanvas::Text.new(x: x, y: y, body: body, background_color: bg_color, foreground_color: fg_color)
          )
        end
    end
  end
end
