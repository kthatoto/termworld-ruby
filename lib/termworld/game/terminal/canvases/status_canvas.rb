module Termworld
  module Terminal
    class StatusCanvas < Termworld::Canvas
      def initialize
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
        level_width = 25
        text(x: 1, y: level_y, body: "Lv. #{$store.user.level}")
        text(x: 1, y: level_y + 1, body: "EXP")
        text(x: 5, y: level_y + 1, body: "▅" * level_width, fg_color: BLACK)
        text(x: 5, y: level_y + 1, body: "▅" * ($store.user_exp_percentage * level_width), fg_color: BLUE)
        text(x: 5, y: level_y + 2, body: $store.user_exp_text)

        hp_y = 5
        hp_width = 25
        text(x: 2, y: hp_y, body: "HP")
        rect(x: 5, y: hp_y, width: hp_width, height: 1, bg_color: BLACK)
        rect(x: 5, y: hp_y, width: $store.user_hp_percentage * hp_width, height: 1, bg_color: Termworld::Canvas.const_get($store.user_hp_color))
        text(x: 5, y: hp_y + 1, body: $store.user_hp_text)

        status_x = 35
        status_y = 2
        text(x: status_x, y: status_y, body: "Status")
        text(x: status_x, y: status_y + 2, body: "ATK. #{$store.user.attack_power}")
        text(x: status_x, y: status_y + 3, body: "DEF. #{$store.user.deffensive_power}")
        text(x: status_x, y: status_y + 4, body: "AGI. ???")
        text(x: status_x, y: status_y + 5, body: "INT. ???")
        text(x: status_x, y: status_y + 6, body: "LUK. ???")

        equipment_x = 55
        equipment_y = 2
        text(x: equipment_x, y: equipment_y, body: "Equipment")
        text(x: equipment_x, y: equipment_y + 2, body: "Head: ---")
        text(x: equipment_x, y: equipment_y + 3, body: "Body: ---")
        text(x: equipment_x, y: equipment_y + 4, body: " Arm: ---")
        text(x: equipment_x, y: equipment_y + 5, body: " Leg: ---")

        ability_x = 75
        ability_y = 2
        text(x: ability_x, y: ability_y, body: "Ability")
        text(x: ability_x, y: ability_y + 2, body: "Slot1. ---")
        text(x: ability_x, y: ability_y + 3, body: "Slot2. ---")
        text(x: ability_x, y: ability_y + 4, body: "Slot3. ---")
      end
    end
  end
end
