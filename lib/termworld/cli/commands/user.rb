module Termworld
  module Commands
    class User < Thor

      desc "create", "Create user"
      def create(*options)
        option_parser = Utils::OptionParserWrapper.new([
          {option: ['-n', '--name [VALUE]', 'User name'], key: :name},
        ])
        params = option_parser.parse!
        return puts option_parser.error_message if option_parser.error_message
        if params[:name].nil?
          print "name: "
          params[:name] = $stdin.gets.chomp
        end

        user = Models::User.new(params)
        result = user.create
        return puts "Failed create user".reden unless result
        puts "Successed create user!".greenen
      end

      desc "list", "List users"
      def list(*options)
        option_parser = Utils::OptionParserWrapper.new([])
        option_parser.parse!
        return puts option_parser.error_message if option_parser.error_message

        users = Models::User.all
        if users.empty?
          puts "No users. Please create user first".bluen
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
