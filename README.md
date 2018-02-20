# CucumberJunitToJson

The Cucumber JUNIT to JSON gem does what it says on the tin. Takes a directory of Cucumber generated JUNIT .xml files, recursively converts them to JSON cucumber compatible format and outputs into a single .json file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cucumber_junit_to_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cucumber_junit_to_json

## Usage

Run:

```bash
cucumber_junit_to_json --junit-dir /path/to/junit/xml --feature-dir /path/to/feature/files
```

The above command will process all JUNIT .xml files in the --junit-dir and link steps to your your .feature file passed on in --feature-dir . Ensure your feature files are up to date with the result from your JUNIT .xml file. All non conformant JUNIT files will be skipped during processing.

JSON result will be stored in cucumber.json by default. To override this name, provide a --output flag with the name of the output file you prefer as below

```bash
cucumber_junit_to_json --junit-dir /path/to/junit/xml --feature-dir /path/to/feature/files --output path/to/output.json
```


Help:

For more information about flags to pass on to the cucumber_junit_to_json executable

```bash
cucumber_junit_to_json --help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ransom4real/cucumber_junit_to_json. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

