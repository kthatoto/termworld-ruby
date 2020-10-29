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

        level_y = 1
        text(x: 2, y: level_y, body: "Lv. #{@store.user.level}")
        text(x: 1, y: level_y + 1, body: "EXP")
        text(x: 5, y: level_y + 1, body: "▅" * 20, fg_color: BLACK)
        text(x: 5, y: level_y + 1, body: "▅" * (@store.user_exp_percentage * 20), fg_color: BLUE)
        text(x: 5, y: level_y + 2, body: @store.user_exp_text)

        hp_y = 5
        text(x: 2, y: hp_y, body: "HP")
        rect(x: 5, y: hp_y, width: 20, height: 1, bg_color: BLACK)
        rect(x: 5, y: hp_y, width: @store.user_hp_percentage * 20, height: 1, bg_color: Termworld::Canvas.const_get(@store.user_hp_color))
        text(x: 5, y: hp_y + 1, body: @store.user_hp_text)
      end
    end
  end
end
