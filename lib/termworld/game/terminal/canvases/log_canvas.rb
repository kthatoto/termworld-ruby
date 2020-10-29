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

        y = 1
        @store.logs.reverse[0...(@canvas.height - 1)].each do |log|
          text(x: 0, y: y, body: log.message,
               bg_color: log.bg_color ? Termworld::Canvas.const_get(log.bg_color) : BACKGROUND_COLOR,
               fg_color: log.fg_color ? Termworld::Canvas.const_get(log.fg_color) : FOREGROUND_COLOR)
          y += 1
        end
      end
    end
  end
end
