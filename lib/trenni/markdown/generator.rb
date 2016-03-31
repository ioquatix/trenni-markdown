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

module Trenni
	module Markdown
		# This parser delegate generates nested code output.
		class Generator
			def initialize(comment_prefix = '# ')
				@comment_prefix = comment_prefix
				@stack = []
				
				@whitespace = String.new
				@output = String.new
			end
			
			attr :output
			
			def indentation
				"\t" * @stack.size
			end
			
			def append_whitespace
				unless @whitespace.empty?
					@output << @whitespace
					@whitespace = String.new
				end
			end
			
			def append(lines, prefix = nil, ignore_whitespace: false)
				append_whitespace unless ignore_whitespace
				
				if prefix
					prefix = indentation + prefix
				else
					prefix = indentation
				end
				
				Array(lines).each do |line|
					@output << prefix << line
				end
			end
			
			def outdent(level)
				# Outdent until we can indent one level:
				while level <= @stack.size
					append(@stack.pop, ignore_whitespace: true)
				end
				
				append_whitespace
			end
			
			def begin_parse(parser)
			end
			
			def end_parse(parser)
				outdent(1)
			end
			
			def open(text)
				@output << text
			end
			
			def close(text)
				@stack.push(text)
			end
			
			def nest(level, first_line, last_line)
				outdent(level)
				
				# We should now be at the point where we can indent:
				append(first_line)
				@stack.push(last_line)
			end
			
			def whitespace(text)
				@whitespace << text
			end
			
			def heading(level, text)
				nest(level, "module #{text}\n", "end\n")
			end
			
			def paragraph(text)
				append(text, @comment_prefix)
			end
			
			def code(text)
				append(text)
			end
		end
	end
end
