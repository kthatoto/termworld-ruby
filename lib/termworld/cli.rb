require "thor"
require "optparse"

require "termworld/db"
require "termworld/commands/account"
require "termworld/commands/daemon_operator"
require "termworld/commands/user"
require "termworld/credential"

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
      return unless Credential.logged_in?(true)
      Commands::DaemonOperator.start
    end
    desc "stop", "Stop game client"
    def stop
      return unless Credential.logged_in?(true)
      Commands::DaemonOperator.stop
    end
    desc "status", "Check status"
    def status
      return unless Credential.logged_in?(true)
      Commands::DaemonOperator.status
    end

    desc "user [COMMAND] <options>", "User actions"
    subcommand "user", Commands::User

    def method_missing(method, *arg, &block)
      _method = method.to_s.split(?:)
      puts "Command:#{_method[0]}"
      puts "Name:#{_method[1]}"
      pp arg
    end
  end
end
