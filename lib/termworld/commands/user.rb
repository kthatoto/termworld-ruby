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

        user = Model::User.new(params)
        result = user.save
        return puts Utils::Color.reden "Failed create user" unless result
        puts Utils::Color.greenen "Successed create user!"
      end

      desc "list", "List users"
      def list(*options)
        params = {}
        begin
          OptionParser.new do |opt|
            opt.parse!(options)
          end
        rescue OptionParser::InvalidOption => e
          puts Utils::Color.reden "Invalid options: #{e.args.first}"
          return
        end

        users = Model::User.all
        if users.empty?
          puts Utils::Color.bluen "No users. Please create user first"
          puts "ex) $ termworld user create --name=<name>"
          return
        end
        users.each do |user|
          puts "id:#{user.id} #{user.name}"
        end
      end
    end
  end
end
