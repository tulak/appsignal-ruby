# frozen_string_literal: true

require "yaml"

module Appsignal
  module Utils
    # @api private
    class YAML
      def self.safe_load(string)
        if ::YAML.respond_to? :safe_load
          if ruby_26_or_up?
            ::YAML.safe_load(string, :aliases => true)
          else
            ::YAML.safe_load(string, nil, nil, true)
          end
        else # Support Ruby versions without YAML.safe_load
          ::YAML.load(string) # rubocop:disable Security/YAMLLoad
        end
      end
    end
  end
end
