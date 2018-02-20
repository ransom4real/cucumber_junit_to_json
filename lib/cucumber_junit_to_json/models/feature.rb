# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber feature attribute
    class Feature
      attr_accessor :keyword, :name, :tags, :description, :elements, :line, :uri, :id
      def initialize
        @description = ''
      end
    end
  end
end
