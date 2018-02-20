# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber scenario attribute
    class Scenario
      attr_accessor :type, :keyword, :name, :tags, :steps, :line, :uri, :description, :id
      def initialize
        @description = ''
      end
    end
  end
end
