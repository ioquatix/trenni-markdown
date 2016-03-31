# Trenni::Markdown

Trenni::Markdown is a light-weight (deliberately) simple Markdown parser. It doesn't cover the entire spec but only a small subset required for implementing [literate](https://en.wikipedia.org/wiki/Literate_programming) unit tests, which are markdown documents which include unit tests.

[![Build Status](https://secure.travis-ci.org/ioquatix/trenni-markdown.svg)](http://travis-ci.org/ioquatix/trenni-markdown)
[![Code Climate](https://codeclimate.com/github/ioquatix/trenni-markdown.svg)](https://codeclimate.com/github/ioquatix/trenni-markdown)
[![Coverage Status](https://coveralls.io/repos/ioquatix/trenni/trenni-markdown.svg)](https://coveralls.io/r/ioquatix/trenni-markdown)

## Motivation

I've been working with [ffi-clang](https://github.com/) to generate documentation for C++ code and I was thinking about what would be the ideal documentation. In most cases, I end up copying examples from the unit tests into the main README. What about if the unit tests were actual markdown which could be compiled, and used to document the code in a very tangible way?

## Installation

Add this line to your application's Gemfile:

	gem 'trenni-markdown'

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install trenni-markdown

## Usage

	input = "# Title\nParagraph\n"
	buffer = Trenni::Buffer.new(input)
	Trenni::Markdown::Parser.new(buffer, delegate).parse!

The delegate must respond to the following callbacks:

	@delegate.heading(level, text)
	@delegate.paragraph(text)
	@delegate.code(lines)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT license.

Copyright, 2012, 2016, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.