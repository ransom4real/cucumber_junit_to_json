# frozen_string_literal: true

require_relative '../models/tag'
# Top level module
module CucumberJunitToJson
  # module for all models
  module Parsers
    # Abstract representation of a cucumber feature file parser
    class FeatureParser
      Error = Class.new(RuntimeError)
      attr_accessor :path_to_features

      def initialize(path_to_features)
        STDERR.puts 'warning: no junit directory given' if path_to_features.empty?
        raise Error, "no such dir(s): #{path_to_features}" unless Dir.exist?(path_to_features)
        @path_to_features = path_to_features
      end

      def tags_and_line_number_matching(file, text)
        tags, line = text_and_line_number_before_match(file, text)
        tag_objects = []
        tags.split(' ').each do |tag|
          if tag.strip.start_with?('@')
            tag_objects.push(CucumberJunitToJson::Models::Tag.new(tag, line - 1))
          end
        end
        [tag_objects, line]
      end

      def text_and_line_number_before_match(file, text)
        count = 0
        prev_line_text = ''
        File.open(file, 'r') do |f|
          f.each_line do |line|
            count += 1
            return prev_line_text, count if line =~ /#{text}/
            prev_line_text = line
          end
        end
      end

      def text_and_line_number_matching(file, text)
        count = 0
        File.open(file, 'r') do |f|
          f.each_line do |line|
            count += 1
            return line, count if line =~ /#{text}/
          end
        end
      end
    end
  end
end
