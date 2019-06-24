require "termworld/terminal/controller"

module Termworld
  module Commands
    class UserAction
      def initialize(name)
        @name = name
      end

      def wakeup(options)
        res = $api_client.call_auth(:get, "/users/#{@name}")
        puts Utils::Color.reden "Login required" if res.code == 401
        puts Utils::Color.reden "User:#{@name} doesn't exsit" if res.code == 404
        user = Models::User.new(JSON.parse(res.body, {symbolize_names: true})[:user])
        user.initialize_position
        user.save_local
        if user.updated
          puts Utils::Color.reden "User:#{user.name} already awake"
        elsif user.created
          puts Utils::Color.greenen "User:#{user.name} woke up!"
        end
      end

      def sleep(options)
        user = Models::User.new(name: @name)
        user.delete_local(by: :name)
        puts Utils::Color.greenen "User:#{user.name} slept!"
      end

      def terminal(options)
        user = Models::User.new(name: @name)
        if !user.bind_local_by_name
          return puts Utils::Color.reden "User:#{@name} is not awake or doesn't exists"
        end
        terminal = Terminal::Controller.new(user)
        terminal.run
      end

      def move(options)
        if options.size != 1 || !%w(up down left right).include?(options.first)
          puts Utils::Color.reden 'Direction must be only up, down, left or right'
          puts "ex) $ termworld user:#{@name} move up"
          return
        end
        direction = options.first.to_sym
        user = Models::User.new(name: @name)
        if !user.bind_local_by_name
          return puts Utils::Color.reden "User:#{@name} is not awake or doesn't exists"
        end
        user.move(direction)
      end

      def method_missing(method, _)
        puts Utils::Color.reden "#{method} command not found"
      end
    end
  end
end
