#!/usr/bin/env rspec

# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'trenni/markdown'

module Trenni::Markdown::ParserSpec
	class ParserDelegate
		def initialize
			@events = []
		end
		
		attr :events
		
		def begin_parse(parser)
		end
		
		def end_parse(parser)
		end
		
		def whitespace(text)
		end
		
		def method_missing(*args)
			@events << args
		end
	end

	RSpec.describe Trenni::Markdown::Parser do
		let(:delegate) {ParserDelegate.new}
		
		def parse(input)
			buffer = Trenni::Buffer.new(input)
			Trenni::Markdown::Parser.new(buffer, delegate).parse!
			
			return delegate
		end
		
		it "should parse a heading" do
			delegate = parse("# Heading 1\n## Heading 2\n")
			
			expect(delegate.events).to be == [
				[:heading, 1, "Heading 1"],
				[:heading, 2, "Heading 2"],
			]
		end
		
		it "should parse single line paragraph" do
			delegate = parse("# Heading 1\nparagraph\n")
			
			expect(delegate.events).to be == [
				[:heading, 1, "Heading 1"],
				[:paragraph, ["paragraph\n"]],
			]
		end
		
		it "should parse multiple line paragraph" do
			delegate = parse("# Heading 1\nfoo bar\nbaz bob\n")
			
			expect(delegate.events).to be == [
				[:heading, 1, "Heading 1"],
				[:paragraph, ["foo bar\n", "baz bob\n"]],
			]
		end
		
		it "should parse a code block" do
			delegate = parse("\tfoo = 10\n\tbar = foo * 2\n")
			
			expect(delegate.events).to be == [
				[:code, ["foo = 10\n", "bar = foo * 2\n"]]
			]
		end
	end
end
