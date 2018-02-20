# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cucumber_junit_to_json/version'

Gem::Specification.new do |spec|
  spec.name          = 'cucumber_junit_to_json'
  spec.version       = CucumberJunitToJson::VERSION
  spec.authors       = ['Voke Ransom Anighoro']
  spec.email         = ['ransom4real@gmail.com']

  spec.summary       = 'Converts cucumber JUNIT xml reports to cucumber JSON format'
  spec.description   = 'Converts cucumber JUNIT xml reports to cucumber JSON format'
  spec.homepage      = 'https://github.com/ransom4real/cucumber_junit_to_json'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables = `git ls-files -- bin/*`.split("\n").map { |f|
    File.basename(f)
  }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'jbuilder', '~> 2.7'
  spec.add_runtime_dependency 'json', '~> 2.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.8'
end
