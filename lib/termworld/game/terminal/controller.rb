require "term_canvas"

require "termworld/game/resources/chip"
require "termworld/game/resources/maps/town"
require "termworld/game/terminal/store"
require "termworld/game/terminal/field_canvas"
require "termworld/game/terminal/meta_canvas"
require "termworld/game/terminal/status_canvas"

module Termworld
  module Terminal
    class Controller
      META_CANVAS_WIDTH = 50
      STATUS_CANVAS_HEIGHT = 10

      def initialize(user)
        @user = user
        @store = Store.new(@user)
        @field_canvas = FieldCanvas.new(@store)
        @meta_canvas = MetaCanvas.new(@store)
        @status_canvas = StatusCanvas.new(@store)
        @canvases = [@field_canvas, @meta_canvas, @status_canvas]
      end

      def run
        loop do
          break if handle_keys == :break
          @store.update
          @canvases.each(&:clear)
          @canvases.each(&:draw)
          @canvases.each(&:update)
          sleep 0.10
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
