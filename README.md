# Haecksler

[![Code Climate](https://codeclimate.com/github/falti/haecksler.png)](https://codeclimate.com/github/falti/haecksler)
[![Build Status](https://travis-ci.org/falti/haecksler.svg?branch=master)](https://travis-ci.org/falti/haecksler)
[![Dependency Status](https://gemnasium.com/falti/haecksler.svg)](https://gemnasium.com/falti/haecksler)
[![Coverage Status](https://coveralls.io/repos/falti/haecksler/badge.png?branch=master)](https://coveralls.io/r/falti/haecksler)


Read fixed-length files:

```
01A Name    20130101SKIPA
```
Support lazy processing so it's possible to read very large files as well.

## Installation

Add this line to your application's Gemfile:

    gem 'haecksler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haecksler

## Usage

```ruby
file = File.open(File.expand_path("../complete.txt",__FILE__))

result = Haecksler.chop(file) do |h|

  h.header_trap {|header| header =~/^FILE/ }
  h.header "HName", 4
  h.header "HExtra", 6

  h.column "Id", 2, :integer
  h.column "Name", 10
  h.column "Date", 8, :date

  h.footer_trap {|footer| footer =~/^END/ }
  h.footer "FFooter", 3
  h.footer "FDate", 8, :date
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/haecksler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
