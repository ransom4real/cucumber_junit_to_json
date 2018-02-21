# frozen_string_literal: true

require 'similar_text'
require_relative 'table'
require_relative 'match'
require_relative 'result'
# Top level module
module CucumberJunitToJson
  # module for all models
  module Models
    # Abstract representation of a cucumber step attribute
    class Step
      attr_accessor :keyword, :name, :match, :table, :result, :line
      def initialize
        @table = CucumberJunitToJson::Models::Table.new
      end

      def self.get_steps_for(scenario_title, scenario_str, feature_file_path, failing_step = nil, failure_message = nil)
        steps = []
        table = []
        prev_step_has_table = false
        keywords = %w[Given When Then And But]
        scenario_steps = scenario_str.split("\n").reject(&:empty?)
        scenario_steps.each do |scenario_step|
          step = Step.new
          scenario_step = scenario_step.to_s.strip
          if scenario_step.start_with?(*keywords)
            # If we are still processing scenarios
            # and the last step had tables, let us
            # process that table
            if prev_step_has_table == true
              steps.last.table = CucumberJunitToJson::Models::Table.parse(table)
              prev_step_has_table = false
              table = []
            end
            step.keyword = scenario_step.split(' ').first.strip
            step.name = scenario_step.split('...').first.split(' ').drop(1).join(' ').strip
            step.match = CucumberJunitToJson::Models::Match.new
            result_duration_str = scenario_step.split('...').last
            status, duration = result_duration_str.split('in')
            step.result = CucumberJunitToJson::Models::Result.new(status, duration)
            if failing_step && failing_step == "#{step.keyword} #{step.name}"
              step.result.error_message = failure_message
            end
            step.line = get_scenario_step_matching(scenario_title, feature_file_path, scenario_step.split('...').first.strip).last
            steps.push(step)
          elsif scenario_step.start_with?('|')
            prev_step_has_table = true
            table.push(scenario_step.to_s.strip)
          end
        end
        # if the last final step had a table
        # it means we would have not had the chance to
        # process it, hence lets do it before we exit this method
        if prev_step_has_table == true
          steps.last.table = CucumberJunitToJson::Models::Table.parse(table)
          prev_step_has_table = false
          table = []
        end
        steps
      end

      def self.get_scenario_step_matching(scenario, file, step)
        count = 0
        found_scenario = false
        File.open(file, 'r') do |f|
          f.each_line do |line|
            count += 1
            # Check if we got a match anchor in line.
            # If there is, use a similar matcher
            if line =~ /<\S+>/
              # A match percentage greater than 80 is an indication
              # of a good match for scenarios
              found_scenario = true if line.similar(scenario) >= 76
            elsif line =~ /#{scenario}/
              found_scenario = true
            end
            if found_scenario
              # Check if we got a match anchor in line.
              # If there is, use a similar matcher
              if line =~ /<\S+>/
                # A match percentage greater than 76 is an indication
                # of a good match for steps
                return line, count if line.similar(step) >= 76
              elsif line =~ /#{step}/
                return line, count
              end
            end
          end
        end
        raise Error, "Could not find step '#{step}' in '#{scenario}' looking into #{file}"
      end
    end
  end
end
