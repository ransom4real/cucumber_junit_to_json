# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step table rows attribute
    class Rows
      attr_accessor :cells, :line
      def initialize(cells, line = 0)
        @cells = cells
        @line = line
      end

      def self.parse(data)
        rows = []
        data.each do |c|
          rows.push(Rows.new(c))
        end
        rows
      end
    end
  end
end
