require 'optparse'
require 'logger'
require 'yaml'
require 'appsignal'
require 'appsignal/cli/helpers'
require 'appsignal/cli/base'
require 'appsignal/cli/info'
require 'appsignal/cli/demo'
require 'appsignal/cli/diagnose'
require 'appsignal/cli/install'
require 'appsignal/cli/notify_of_deploy'

module Appsignal
  class CLI
    COMMANDS = {
      "demo" => Appsignal::CLI::Demo,
      "diagnose" => Appsignal::CLI::Diagnose,
      "install" => Appsignal::CLI::Install,
      "notify_of_deploy" => Appsignal::CLI::NotifyOfDeploy,
    }.freeze

    class << self
      def run(argv = ARGV)
        command_name = argv.shift
        unless command_name
          command = Appsignal::CLI::Info
          options = {}
          command.options(options).parse!(argv)
          command.new(nil, options).run
          return
        end

        command = command_for(command_name)
        if command
          options = {}
          command.options(options).parse!(argv)
          command.new(argv, options).run
        else
          puts "Command '#{command_name}' does not exist, run appsignal "\
            "--help to see the help."
          exit 1
        end
      end

      private

      def command_for(name)
        COMMANDS[name]
      end
    end
  end
end
