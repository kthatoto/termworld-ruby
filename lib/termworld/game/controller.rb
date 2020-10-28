require "term_canvas"

require "termworld/game/abstracts/map"
require "termworld/game/resources/chip"
require "termworld/game/resources/maps/town"
require "termworld/game/terminal/store"
require "termworld/game/terminal/canvases/field_canvas"
require "termworld/game/terminal/canvases/meta_canvas"
require "termworld/game/terminal/canvases/status_canvas"
require "termworld/game/terminal/canvases/log_canvas"

module Termworld
  module Terminal
    class Controller
      META_CANVAS_WIDTH = 50
      META_CANVAS_HEIGHT = 30
      STATUS_CANVAS_HEIGHT = 10

      def initialize(user)
        @user = user
        @store = Store.new(@user)
        @field_canvas = FieldCanvas.new(@store)
        @meta_canvas = MetaCanvas.new(@store)
        @status_canvas = StatusCanvas.new(@store)
        @log_canvas = LogCanvas.new(@store)
        @canvases = [@field_canvas, @meta_canvas, @status_canvas, @log_canvas]
      end

      def run
        loop do
          break if handle_keys == :break
          @store.update
          @canvases.each(&:clear)
          @canvases.each(&:draw)
          @canvases.each(&:update)
          TermCanvas.update
          sleep 0.10
        rescue => e
          puts e
          sleep 10
          break
        end
        TermCanvas.close
      end

      private

        def handle_keys
          key = TermCanvas.gets
          case key
          when ?q
            return :break
          when ?h
            @user.move(:left)
          when ?j
            @user.move(:down)
          when ?k
            @user.move(:up)
          when ?l
            @user.move(:right)
          end
        end
    end
  end
end
