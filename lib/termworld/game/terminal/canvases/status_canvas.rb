module Termworld
  module Terminal
    class StatusCanvas < Termworld::Canvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: 0,
          y: TermCanvas.height - Controller::STATUS_CANVAS_HEIGHT,
          w: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          h: Controller::STATUS_CANVAS_HEIGHT,
        )
      end

      def draw
        @canvas.background(BACKGROUND_COLOR)
        text(x: 1, y: 1, body: "HP")
        rect(x: 4, y: 1, width: 20, height: 1, bg_color: BLACK)
        rect(x: 4, y: 1, width: @store.user_hp_percentage, height: 1, bg_color: BLACK)
        text(x: 4, y: 2, body: @store.user_hp_text, bg_color: Object.const_get(@store.user_hp_color))
      end
    end
  end
end
