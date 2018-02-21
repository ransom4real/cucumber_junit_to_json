# frozen_string_literal: true

require 'optparse'
require 'find'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'pathname'
require_relative 'models/feature'
require_relative 'models/scenario'
require_relative 'models/step'
require_relative 'feature_json_builder'
require_relative 'parsers/feature_parser'
require_relative 'parsers/junit_parser'
require_relative 'version'

module CucumberJunitToJson
  # The Cucumber Junit to Json app class that handles std inputs and command line args
  class App
    Error = Class.new(RuntimeError)

    def initialize(options = {})
      @stdin  = options[:stdin] || STDIN
      @stdout = options[:stdout] || STDOUT
      @stderr = options[:stderr] || STDERR
      @feature_id = 1
      @scenario_id = 1
    end

    attr_reader :stdin, :stdout, :stderr, :junit_parser, :feature_parser

    def run(*args)
      options = parse_args(args)
      @junit_parser = CucumberJunitToJson::Parsers::JunitParser.new(options.junit_dir)
      @feature_parser = CucumberJunitToJson::Parsers::FeatureParser.new(options.feature_dir)
      output_file = options.output_file || 'cucumber.json'
      features = []
      unless File.file?(output_file)
        output_directory = File.dirname(output_file)
        FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
        FileUtils.touch(output_file)
        raise Error, "Could not create output file #{output_file}" unless File.file?(output_file)
      end
      # if we are dealing with a directory of xml files
      if File.directory?(junit_parser.path_to_junit)
        Find.find(junit_parser.path_to_junit) do |path_to_file|
          next unless File.file?(path_to_file) && File.extname(path_to_file) == '.xml'
          features.push(convert_to_json(path_to_file))
        end
        # if we are dealing with just a single xml file
      elsif File.exist?(junit_parser.path_to_junit)
        features.push(convert_to_json(junit_parser.path_to_junit))
      end
      open(output_file, 'w') { |f| f.write(features.to_json) }
      0
    rescue Error, OptionParser::ParseError => error
      stderr.puts error.message
      1
    end

    private

    def convert_to_json(file)
      file_content = @junit_parser.read(file)

      return if file_content.empty?

      document = Nokogiri::XML::Document.parse(file_content)
      testsuite = document.at_css('testsuite')
      feature_uri = Pathname.new(File.join(@feature_parser.path_to_features, @junit_parser.path_to_file(testsuite['name']))).realpath.to_s
      feature = CucumberJunitToJson::Models::Feature.new
      feature.keyword = 'Feature'
      feature.name = @junit_parser.feature_name(testsuite['name'])
      feature.uri = feature_uri
      feature.id = @feature_id
      feature.tags, feature.line = @feature_parser.tags_and_line_number_matching(feature_uri, "#{feature.keyword}:")

      testcases = testsuite.css('testcase')
      scenarios = []
      testcases.each do |testcase|
        scenario = CucumberJunitToJson::Models::Scenario.new
        # Removing scenario outline added blob gives you the actual scenario name
        scenario.name = testcase['name'].split('-- @').first.strip
        scenario.tags, scenario.line = @feature_parser.tags_and_line_number_matching(feature_uri, scenario.name)
        scenario_line_text = @feature_parser.text_and_line_number_matching(feature_uri, scenario.name).first
        scenario.keyword = scenario_line_text.split(':').first.strip
        scenario.type = 'scenario'
        scenario.uri = feature_uri
        scenario.id = @scenario_id
        scenario_output = get_string_between(testcase.at_css('system-out').text, '@scenario.begin', '@scenario.end')
        scenario.steps = CucumberJunitToJson::Models::Step.get_steps_for(scenario.name, scenario_output, feature_uri)
        scenarios.push(scenario)
        @scenario_id += 1
      end
      feature.elements = scenarios
      builder = CucumberJunitToJson::FeatureJsonBuilder.new(feature)
      @feature_id += 1
      JSON.parse(builder.feature_json)
    end

    def get_string_between(str, start_at, end_at)
      regex = /#{start_at}(.*?)#{end_at}/m
      str[regex, 1]
    end

    def parse_args(args)
      options = OpenStruct.new
      options.junit_dir = nil
      options.feature_dir = nil
      options.output_file = nil
      parser = OptionParser.new do |p|
        p.banner = "USAGE: #{$PROGRAM_NAME} --junit-dir JUNITDIR --feature-dir FEATUREDIR"
        p.separator ''
        p.separator 'Specific options:'

        p.on '-j', '--junit-dir JUNITDIR', 'Provide a path to junit .xml files.' do |junit_dir|
          options.junit_dir = junit_dir
        end

        p.on '-f', '--feature-dir FEATUREDIR', 'Provide a path to .feature files.' do |feature_dir|
          options.feature_dir = feature_dir
        end

        p.on '-o', '--output [OUTPUT]', 'Provide a path to output json file.' do |output|
          options.output_file = output
        end

        p.on_tail('-h', '--help', 'Show this message') do
          puts p
          exit
        end

        # Another typical switch to print the version.
        p.on_tail('--version', 'Show version') do
          puts CucumberJunitToJson::VERSION
          exit
        end
      end

      parser.parse!(args)
      raise Error, parser.banner unless options.junit_dir && options.feature_dir
      options
    end
  end
end
