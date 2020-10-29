module Termworld
  module Terminal
    class MetaCanvas < Termworld::Canvas
      def initialize(store)
        @store = store
        @canvas = TermCanvas::Canvas.new(
          x: TermCanvas.width - Controller::META_CANVAS_WIDTH,
          y: 0,
          w: Controller::META_CANVAS_WIDTH,
          h: Controller::META_CANVAS_HEIGHT,
        )
      end

      def draw
        @canvas.background(BACKGROUND_COLOR)
        text(x: 1, y: 1, body:   "current map: #{@store.map.name}")
        text(x: 1, y: 3, body:   "   position: {x: #{@store.user.positionx}, y: #{@store.user.positiony}}")

        text(x: 1, y: 5, body:   "    players:")
        y = 5
        if @store.users.size == 0
          text(x: 14, y: y, body: "-----")
          y += 1
        else
          @store.users.each do |u|
            text(x: 14, y: y, body: "#{u.name}: {x: #{u.positionx}, y: #{u.positiony}}")
            y += 1
          end
        end
        y += 1

        text(x: 1, y: y, body: "    enemies:")
        if @store.enemies.size == 0
          text(x: 14, y: y, body: "-----")
        else
          hp_width = 20
          @store.enemies.each do |e|
            text(x: 14, y: y, body: "#{e.name}(Lv.#{e.level}): {x: #{e.positionx}, y: #{e.positiony}}")
            y += 1
            text(x: 14, y: y, body: "▅" * hp_width, fg_color: BLACK)
            hpp = e.hp.to_f / e.max_hp
            text(x: 14, y: y, body: "▅" * (hpp * hp_width).to_i, fg_color: hpp > 0.3 ? GREEN : hpp > 0.1 ? YELLOW : RED)
            text(x: 14 + hp_width + 2, y: y, body: "#{e.hp} / #{e.max_hp}")
            y += 2
          end
        end
      end
    end
  end
end
