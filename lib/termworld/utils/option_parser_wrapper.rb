require "optparse"

module Termworld
  module Utils
    class OptionParserWrapper
      attr_reader :error_message
      def initialize(options)
        @options = options
      end
      def parse!
        params = {}
        begin
          OptionParser.new do |op|
            @options.each do |option|
              op.on(*option[:option]) { |v| params[option[:key]] = v }
            end
            op.parse!(**params)
          end
        rescue OptionParser::InvalidOption => e
          @error_message = Utils::Color.reden "Invalid options: #{e.args.first}"
          return {}
        end
        params
      end
    end
  end
end
