# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step result attribute
    class Result
      attr_accessor :status, :duration
      def initialize(status, duration)
        @status = status.to_s.strip
        @duration = duration.to_f
      end
    end
  end
end
