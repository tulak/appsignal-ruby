module Appsignal
  class CLI
    class Info < Base
      def self.options(opts = {})
        OptionParser.new do |o|
          o.banner = "Usage: appsignal <command> [options]"

          o.on "-v", "--version", "Print version and exit" do |arg|
            puts "AppSignal #{Appsignal::VERSION}"
            exit 0
          end

          o.on "-h", "--help", "Show help and exit" do
            puts o
            exit 0
          end

          o.separator ""
          o.separator "Available commands:"

          commands = ::Appsignal::CLI::COMMANDS
          max_command_length = commands.keys.sort_by(&:length).last.length
          name_length = max_command_length + 2
          commands.each do |name, command|
            next if name.empty?
            o.separator "  #{name.ljust(name_length)} # #{command.description}"
          end
        end
      end

      def run
        puts self.class.options
        exit 0
      end
    end
  end
end
