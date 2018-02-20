# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step definition match attribute
    class Match
      attr_accessor :location, :arguments
      def initialize(location = '', arguments = [])
        @location = location
        @arguments = arguments
      end
    end
  end
end
