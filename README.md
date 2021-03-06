# SpfChecker

This gem allows you to check domain SPF record and compare it with correct one.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spf_checker', github: 'Freika/spf_checker'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install spf_checker

## Usage

```ruby
checker = SpfChecker::Domain.new("v=spf1 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com ~all")

checker.check('google.com')
#  #<struct SpfChecker::Domain::Response correct=true, spf_value=#<SPF::Query::Record: v=spf1 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com ~all>>
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests. You can also run `rake console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freika/spf_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

