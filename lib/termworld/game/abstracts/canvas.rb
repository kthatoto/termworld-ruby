module Termworld
  class Canvas
    def clear
      @canvas.clear
    end

    def update
      @canvas.update
    end

    BACKGROUND_COLOR = {r:  300, g:  300, b:  400}
    FOREGROUND_COLOR = {r: 1000, g: 1000, b: 1000}
    GREEN  = {r:  200, g:  800, b:  200}
    YELLOW = {r:  800, g:  700, b:  200}
    RED    = {r:  800, g:  200, b:  200}
    BLACK  = {r:    0, g:    0, b:    0}
    WHITE  = {r: 1000, g: 1000, b: 1000}

    private

      def text(x:, y:, body:, bg_color: BACKGROUND_COLOR, fg_color: FOREGROUND_COLOR)
        @canvas.text(
          TermCanvas::Text.new(x: x, y: y, body: body, background_color: bg_color, foreground_color: fg_color)
        )
      end

      def rect(x:, y:, width:, height:, bg_color:)
        @canvas.rect(
          TermCanvas::Rect.new(x: x, y: y, width: width, height: height, background_color: bg_color)
        )
      end
  end
end
