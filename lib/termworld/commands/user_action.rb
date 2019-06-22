module Termworld
  module Commands
    class UserAction
      def initialize(name)
        @name = name
      end

      def awake(options)
      end

      def method_missing(method, _)
        puts Utils::Color.reden "#{method} command not found"
      end
    end
  end
end
