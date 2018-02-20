# frozen_string_literal: true

# Top level module
module CucumberJunitToJson
  # module for all models
  module Parsers
    # Abstract representation of a junit xml file parser
    class JunitParser
      Error = Class.new(RuntimeError)
      attr_accessor :path_to_junit
      def initialize(path_to_junit)
        STDERR.puts 'warning: no junit directory given' if path_to_junit.empty?
        raise Error, "no such dir(s): #{path_to_junit}" unless Dir.exist?(path_to_junit)
        @path_to_junit = path_to_junit
      end

      def read(file)
        File.read(file).encode!('UTF-8', invalid: :replace)
      end

      def path_to_file(str)
        arr = str.split('.')
        "#{arr.first(arr.size - 1).join('/')}.feature"
      end

      def feature_name(str)
        str.split('.').last.strip
      end
    end
  end
end
