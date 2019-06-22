require "thor"
require "json"

require "termworld/db"
require "termworld/commands/account"
require "termworld/commands/daemon_operator"
require "termworld/commands/user"
require "termworld/commands/user_action"
require "termworld/credential"
require "termworld/utils/option_parser_wrapper"

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
      credential = Credential.new
      return puts credential.error_message unless credential.logged_in?
      Commands::DaemonOperator.start
    end
    desc "stop", "Stop game client"
    def stop
      credential = Credential.new
      unless credential.logged_in?
        Daemon.new(:force_stop).stop
        return puts credential.error_message
      end
      Commands::DaemonOperator.stop
    end
    desc "status", "Check status"
    def status
      credential = Credential.new
      return puts credential.error_message unless credential.logged_in?
      Commands::DaemonOperator.status
    end

    desc "user [COMMAND] <options>", "User actions"
    subcommand "user", Commands::User

    def method_missing(method, *arg, &block)
      _method = method.to_s.split(?:)
      begin
        action_class = Object.const_get("Termworld::Commands::#{_method[0].capitalize}Action")
      rescue
        puts Utils::Color.reden "#{_method[0]} command not found"
        return
      end
      action = action_class.new(_method[1])
      return puts Utils::Color.reden "Enter any commands" if arg.empty?
      action.send(arg[0], arg[1..-1])
    end
  end
end
