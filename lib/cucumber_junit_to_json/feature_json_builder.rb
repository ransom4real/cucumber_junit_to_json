# frozen_string_literal: true

require 'jbuilder'
# Top level module
module CucumberJunitToJson
  # Uses JBuilder to model a JSON feature object
  class FeatureJsonBuilder
    attr_accessor :feature_json
    def initialize(feature)
      @feature_json = Jbuilder.encode do |json|
        json.keyword feature.keyword
        json.name feature.name
        json.tags feature.tags do |tag|
          json.name tag.name
          json.line tag.line
        end
        json.elements feature.elements do |scenario|
          json.type scenario.type
          json.keyword scenario.keyword
          json.name scenario.name
          json.tags scenario.tags do |tag|
            json.name tag.name
            json.line tag.line
          end
          json.steps scenario.steps do |step|
            json.keyword step.keyword
            json.name step.name
            json.match do
              json.location step.match.location
              json.arguments step.match.arguments
            end
            json.result do
              json.status step.result.status
              json.duration step.result.duration
            end
            unless step.table.headings.size.zero?
              json.table do
                json.headings step.table.headings
                json.rows step.table.rows
              end
            end
            json.line step.line
          end
          json.line scenario.line
          json.uri scenario.uri
          json.description scenario.description
          json.id scenario.id
        end
        json.description feature.description
        json.line feature.line
        json.uri feature.uri
        json.id feature.id
      end
    end
  end
end
