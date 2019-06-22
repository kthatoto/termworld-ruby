require "optparse"

module Termworld
  module Utils
    class OptionParser
      def initialize(options)
        @options = options
      end
      def parse!
        params = {}
        OptionParser.new do |op|
          @options.each do |option|
            op.on(*option.option) { |v| params[option.key] = v }
          end
          op.parse!(@options)
        end
        params
      rescue OptionParser::InvalidOption => e
        @error_message = Utils::Color.reden "Invalid options: #{e.args.first}"
        {}
      end
    end
  end
end
