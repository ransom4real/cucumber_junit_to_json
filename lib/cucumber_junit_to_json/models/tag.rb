# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber tag attribute
    class Tag
      attr_accessor :name, :line
      def initialize(name, line)
        @name = name
        @line = line
      end
    end
  end
end
