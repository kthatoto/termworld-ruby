module Termworld
  class Canvas
    def clear
      @canvas.clear
    end

    def update
      @canvas.update
    end

    private

      BACKGROUND_COLOR = {r:  300, g:  300, b:  400}
      FOREGROUND_COLOR = {r: 1000, g: 1000, b: 1000}
      def text(x:, y:, body:, bg_color: BACKGROUND_COLOR, fg_color: FOREGROUND_COLOR)
        @canvas.text(
          TermCanvas::Text.new(x: x, y: y, body: body, background_color: bg_color, foreground_color: fg_color)
        )
      end
  end
end
