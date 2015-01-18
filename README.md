# FailedTagFormatter

A simple formatter that writes failed specs to a file,
in JSON format.  The added feature over the stock
JSON formatter is the addition of tags, and only showing
the failed specs.

This can be useful for doing failed analysis in CI.


## Installation

Add this line to your application's Gemfile in the development and test groups, where rspec and other formatters are located:

```ruby
gem 'failed_tag_formatter'
```

And then execute:

    $ bundle


## Usage

Add `--format FailedTagFormatter` to the options that RSpec uses.
See the [RSpec docs](https://relishapp.com/rspec/rspec-core/v/2-6/docs/command-line/format-option) on --format for more info.


Environment variables can control some optional behavior:




## Contributing

1. Fork it ( https://github.com/edk/failed_tag_formatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
