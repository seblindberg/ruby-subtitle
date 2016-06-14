# Ruby-Subtitle

This gem implements a generic representation of a subtitle in Ruby. The goal is to support reading, parsing and writing to the most common subtitle formats out there, such as SubRip (.srt) and MicroDVD (.sub), while providing an intermediary format that is easy to work with in code.

Taking cues from the different subtitle formats out there, a subtitle is modelled as a collection of lines, where each line has a defined start and end time. The lines also support a number of different formatting options, such as font weight, text color and so on. 

There is a large focus on timing, with built in support for quite complex time shifting operations. Both the whole subtitle, as well as individual lines, can be shifted in time relative to their original positions.

Another area of focus is iteration, with many different iterating methods supporting looping over lines both forwards and in reverse, freely and in between boundaries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subtitle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subtitle

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/subtitle.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

