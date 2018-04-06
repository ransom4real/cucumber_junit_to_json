# frozen_string_literal: true

require 'similar_text'
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

      def tags_and_line_number_matching(file, text, similar = false)
        tags, line = text_and_line_number_before_match(file, text, similar)
        tag_objects = []
        tags.split(' ').each do |tag|
          if tag.strip.start_with?('@')
            tag_objects.push(CucumberJunitToJson::Models::Tag.new(tag, line - 1))
          end
        end
        [tag_objects, line]
      end

      def text_and_line_number_before_match(file, text, similar = false)
        count = 0
        prev_line_text = ''
        File.open(file, 'r') do |f|
          f.each_line do |line|
            count += 1
            if similar && line =~ /<\S+>/
              return prev_line_text, count if line.similar(text) >= 73
            elsif line =~ /#{text}/
              return prev_line_text, count
            end
            prev_line_text = line
          end
        end
        raise Error, "Could not find #{text} in #{file}"
      end

      def text_and_line_number_matching(file, text, similar = false)
        count = 0
        File.open(file, 'r') do |f|
          f.each_line do |line|
            count += 1
            if similar || line =~ /<\S+>/
              return line, count if line.similar(text) >= 73
            elsif line =~ /#{text}/
              return line, count
            end
          end
        end
        raise Error, "Could not find #{text} in #{file}"
      end
    end
  end
end
