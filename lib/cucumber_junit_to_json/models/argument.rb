# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step argument attribute
    class Argument
      attr_accessor :value
    end
  end
end
