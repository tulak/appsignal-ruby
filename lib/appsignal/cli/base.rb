module Appsignal
  class CLI
    class Base
      def self.description
      end

      def self.options(_ = {})
        OptionParser.new
      end

      attr_reader :arguments, :options

      def initialize(args = [], opts = {})
        @arguments = args
        @options = opts
      end

      private

      def config_for(environment, initial_config = {})
        Appsignal::Config.new(
          Dir.pwd,
          environment,
          initial_config,
          Logger.new(StringIO.new)
        )
      end
    end
  end
end
