# Foobara::Util

Just a bunch of utility functions used across various Foobara projects

## Installation

If trying to use this outside of Foobara, you can place it in your Gemfile as `gem foobara-util` or your .gemspec
as `spec.add_dependency "foobara-util"` and then you can run `bundle`.

## Usage

To have all utility functions available at runtime, use:

```ruby
require "foobara/util"
```

But if you only want specific functionality available, require those parts:

```angular2html
require "foobara/util/string"
require "foobara/util/module"
# etc...
```

## Development

After checking out the repo, run `bundle` to install dependencies.

Then, run `rake` to run the tests and linter.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, update `CHAGENLOG.md`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foobara/util

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
