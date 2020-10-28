require "thor"
require "json"

require "termworld/commands/account"
require "termworld/commands/daemon_operator"
require "termworld/commands/user"
require "termworld/commands/user_action"
require "termworld/credential"
require "termworld/utils/option_parser_wrapper"
require "termworld/game/db"

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
      action = action_class.new(_method[1])
      return puts "Enter any commands".reden if arg.empty?
      action.send(arg[0], arg[1..-1])
    end
  end
end
