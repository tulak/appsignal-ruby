module Appsignal
  class CLI
    class NotifyOfDeploy < CLI::Base
      def self.description
        "Notify AppSignal of a deploy, creating a marker in the AppSignal UI."
      end

      def self.options(opts = {})
        OptionParser.new do |o|
          o.banner = 'Usage: appsignal notify_of_deploy [options]'

          o.on '--revision=<revision>', "The revision you're deploying" do |arg|
            opts[:revision] = arg
          end

          o.on '--user=<user>', "The name of the user that's deploying" do |arg|
            opts[:user] = arg
          end

          o.on '--environment=<rails_env>', "The environment you're deploying to" do |arg|
            opts[:environment] = arg
          end

          o.on '--name=<name>', "The name of the app (optional)" do |arg|
            opts[:name] = arg
          end
        end
      end

      def run
        config = config_for(options[:environment])
        config[:name] = options[:name] if options[:name]

        validate_active_config(config)
        required_config = [:revision, :user]
        required_config << :environment if config.env.empty?
        required_config << :name if !config[:name] || config[:name].empty?
        validate_required_options(options, required_config)

        Appsignal::Marker.new(
          {
            :revision => options[:revision],
            :user => options[:user]
          },
          config
        ).transmit
      end

      private

      def validate_active_config(config)
        return if config.active?

        puts "Error: No valid config found."
        exit 1
      end

      def validate_required_options(options, required_options)
        missing = required_options.select do |required_option|
          val = options[required_option]
          val.nil? || (val.respond_to?(:empty?) && val.empty?)
        end
        return if missing.empty?

        puts "Error: Missing options: #{missing.join(', ')}"
        exit 1
      end
    end
  end
end
