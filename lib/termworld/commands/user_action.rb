require "termworld/game/terminal/controller"

module Termworld
  module Commands
    class UserAction
      def initialize(name)
        @name = name
      end

      COMMANDS = [
        { label: "wakeup",           description: "Wakeup user" },
        { label: "sleep",            description: "Sleep user" },
        { label: "terminal",         description: "Start operating user by your terminal" },
        { label: "move <direction>", description: "Move user [:up, :down, :left, :right]" },
      ]

      def wakeup(options)
        res = $api_client.call_auth(:get, "/users/#{@name}")
        puts "Login required".reden if res.code == 401
        puts "User:#{@name} doesn't exist".reden if res.code == 404
        user = Models::User.new(JSON.parse(res.body, {symbolize_names: true})[:user])
        user.initialize_position
        user.save_local
        if user.updated
          puts "User:#{user.name} already awake".reden
        elsif user.created
          puts "User:#{user.name} woke up!".greenen
        end
      end

      def sleep(options)
        user = Models::User.new(name: @name)
        user.delete_local(by: :name)
        puts "User:#{user.name} slept!".greenen
      end

      def terminal(options)
        user = Models::User.new(name: @name)
        if !user.bind_local_by_name
          return puts "User:#{@name} is not awake or doesn't exists".reden
        end
        terminal = Terminal::Controller.new(user)
        terminal.run
      end

      def move(options)
        if options.size != 1 || !%w(up down left right).include?(options.first)
          puts "Direction must be only up, down, left or right".reden
          puts "ex) $ termworld user:#{@name} move up"
          return
        end
        direction = options.first.to_sym
        user = Models::User.new(name: @name)
        if !user.bind_local_by_name
          return puts "User:#{@name} is not awake or doesn't exists".reden
        end
        user.move(direction)
      end

      def method_missing(method, _)
        puts "\"#{method}\" command not found".reden
      end
    end
  end
end
