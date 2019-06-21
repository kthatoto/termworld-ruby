module Termworld
  module Commands
    class User < Thor

      desc "create", "Create user"
      def create(*options)
        params = {}
        begin
          OptionParser.new do |opt|
            opt.on('-n', '--name=[VALUE]', 'User name') { |v| params[:name] = v }
            opt.parse!(options)
          end
        rescue OptionParser::InvalidOption => e
          puts Utils::Color.reden "Invalid options: #{e.args.first}"
          return
        end
        if params[:name].nil?
          print "name: "
          params[:name] = $stdin.gets.chomp
        end

        # if name.empty? || !name.scan(/[^0-9a-z]+/i).empty?
        #   puts Utils::Color.reden "Name must have only alphanumeric"
        #   return
        # end
      end
    end
  end
end
