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

      BACKGROUND_COLOR = {r:  300, g:  300, b:  400}
      FOREGROUND_COLOR = {r: 1000, g: 1000, b: 1000}
      def draw
        @canvas.background(BACKGROUND_COLOR)
        text(x: 1, y: 1, body: "current map: #{@store.map.name}")
        text(x: 1, y: 3, body: "   position: { x: #{@store.user.positionx}, y: #{@store.user.positiony} }")
      end

      private

        def text(x:, y:, body:)
          @canvas.text(
            TermCanvas::Text.new(
              x: x, y: y, body: body,
              background_color: BACKGROUND_COLOR,
              foreground_color: FOREGROUND_COLOR,
            )
          )
        end
    end
  end
end
