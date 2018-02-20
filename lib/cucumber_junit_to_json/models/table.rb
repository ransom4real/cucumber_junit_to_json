# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step table attribute
    class Table
      attr_accessor :headings, :rows
      def initialize
        @headings = []
        @rows = []
      end

      def self.parse(data)
        table = Table.new
        table.headings = data.first.split('|').compact.collect(&:strip).reject(&:empty?)
        rows = []
        data.drop(1).each do |row|
          rows.push(row.split('|').compact.collect(&:strip).reject(&:empty?))
        end
        table.rows = rows
        table
      end
    end
  end
end
