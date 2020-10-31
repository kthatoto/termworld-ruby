require "thor"
require "json"

Dir["./**/*.rb"].each {|file| require file}

module Termworld
  class CLI < Thor

    desc "login", "Login"
    def login
      Commands::Account.login
    end
    desc "logout", "Logout"
    def logout
      Commands::Account.logout
    end

    desc "start", "Start game client"
    def start
      Commands::DaemonOperator.start
    end
    desc "stop", "Stop game client"
    def stop
      Commands::DaemonOperator.stop
    end
    desc "status", "Check status"
    def status
      Commands::DaemonOperator.status
    end

    desc "user [COMMAND] <options>", "User actions"
    subcommand "user", Commands::User

    def method_missing(method, *arg, &block)
      _method = method.to_s.split(?:)
      begin
        action_class = Object.const_get("Termworld::Commands::#{_method[0].capitalize}Action")
      rescue
        puts "#{_method[0]} command not found".reden
        return
      end
      if arg.empty?
        puts "Commands:"
        commands = action_class::COMMANDS
        longest_command_size = commands.max_by {|c| c[:label].size}[:label].size
        commands.each do |command|
          command_label = "  termworld #{method} #{command[:label]}"
          command_label += (" " * (longest_command_size - command[:label].size + 1))
          puts "#{command_label} # #{command[:description]}"
        end
        puts
        return
      end

      action = action_class.new(_method[1])
      action.send(arg[0], arg[1..-1])
    end

    class << self
      def exit_on_failure?
        true
      end
    end
  end
end
