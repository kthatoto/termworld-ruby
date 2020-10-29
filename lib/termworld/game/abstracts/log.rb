module Termworld
  class Log
    attr_accessor :type, :message

    TYPE_FG_COLOR = {
      attack: "GREEN",
      defend: "RED",
      defeat: "GREEN",
      levelup: "BLACK",
    }
    TYPE_BG_COLOR = {
      levelup: "GREEN",
    }
    def initialize(params)
      @type = params[:type]
      @message = params[:message]
    end

    def fg_color
      TYPE_FG_COLOR[@type.to_sym]
    end

    def bg_color
      TYPE_BG_COLOR[@type.to_sym]
    end
  end
end
