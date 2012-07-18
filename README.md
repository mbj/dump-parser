dump-parser
===========

[![Build Status](https://secure.travis-ci.org/mbj/dump-parser.png?branch=master)](http://travis-ci.org/mbj/dump-parser)
[![Dependency Status](https://gemnasium.com/mbj/dump-parser.png)](https://gemnasium.com/mbj/dump-parser)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mbj/dump-parser)

A simple and dump dsl for converting strings, most likely from legacy csv fields into something more interesting.

Installation
------------

In your **Gemfile**

``` ruby
gem 'dump-parser', :git => 'https://github.com/mbj/dump-parser'
```

Examples
--------

``` ruby
require 'dump-parser'

# Yeah does not look very nice, but could not come up with something better.
DumpParser.register :dd_mm_yyyy_date_time do
  nil_if_empty
  require_format(%r(\A(\d{2})\.(\d{2})\.(\d{4})\z))
  begin
    DateTime.new(match[3].to_i(10), match[2].to_i(10), match[1].to_i(10))
  rescue ArgumentError
    parse_error('is invalid date')
  end
end

DumpParser.register :required_integer do
  require_format(%r(\A\d+\z))
  value.to_i(10)
end

DumpParser.execute(:dd_mm_yyyy_date_time, "")            # => nil
DumpParser.execute(:dd_mm_yyyy_date_time, "10.01.1901")  # => DateTime.new(1901,01,10)
DumpParser.execute(:dd_mm_yyyy_date_time, "invalid")     # raises DumpParser::ParseError 'dd_mm_yyyy_date: value "invalid" does not match required format')
DumpParser.execute(:dd_mm_yyyy_date_time, "31.02.2011")  # raises DumpParser::ParseError 'dd_mm_yyyy_date: value "31.02.2011" is invalid date')
```

Credits
-------

Your name is missing here!

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

Copyright (c) 2012 Markus Schirp

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
