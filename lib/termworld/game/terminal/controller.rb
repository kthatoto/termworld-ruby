require "term_canvas"

require "termworld/game/resources/chip"
require "termworld/game/resources/maps/town"

module Termworld
  module Terminal
    class Controller
      def initialize(user)
        @user = user
        @map = Resources::Maps::Town.new

        meta_canvas_width = 50
        status_canvas_height = 10
        @field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width - meta_canvas_width, h: TermCanvas.height - status_canvas_height)
        @meta_canvas = TermCanvas::Canvas.new(x: @field.width, y: 0, w: meta_canvas_width, h: TermCanvas.height)
        @status_canvas = TermCanvas::Canvas.new(x: 0, y: @field.height, w: TermCanvas.width - meta_canvas_width, h: status_canvas_height)
        @canvases = [@field, @meta_canvas, @status_canvas]
      end

      def run
        loop do
          break if handle_keys == :break
          @users = Models::User.all_local.reject {|user| user.name == @user.name}
          @canvases.each(&:clear)

          draw_field
          draw_meta
          draw_status

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

        def draw_field
          height = @field.height
          width = @field.width / 2 - 1

          height.times do |y|
            width.times do |x|
              abs_position = {
                x: @user.positionx - (width / 2) + x,
                y: @user.positiony - (height / 2) + y,
              }
              user = @users.find { |u|
                u.positionx == abs_position[:x] && u.positiony == abs_position[:y]
              }
              if user
                player_chip = Resources::Chip.new(x: x * 2 + 1, y: y, key: "pl")
                @field.rect(player_chip.rect)
                next
              end
              next if abs_position.any? { |_, v| v < 0 }
              next if (chip = @map.get_chip(abs_position)).nil?
              @field.rect(chip.rect.position_override(x: x * 2 + 1, y: y))
            end
          end

          player_chip = Resources::Chip.new(x: @field.centerx, y: @field.centery, key: "pl")
          @field.rect(player_chip.rect)
        end

        def draw_meta
          @meta_canvas.rect(
            TermCanvas::Rect.new(
              x: 0, y: 0, width: @meta_canvas.width - 1, height: @meta_canvas.height,
              background_color: {r: 300, g: 300, b: 400},
            )
          )
        end

        def draw_status
          @status_canvas.rect(
            TermCanvas::Rect.new(
              x: 0, y: 0, width: @status_canvas.width - 1, height: @status_canvas.height,
              background_color: {r: 300, g: 300, b: 400},
            )
          )
        end
    end
  end
end
