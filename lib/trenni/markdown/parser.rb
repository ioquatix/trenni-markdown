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

require 'trenni/scanner'

module Trenni
	module Markdown
		# This parser processes general markup into a sequence of events which are passed to a delegate.
		class Parser < StringScanner
			def initialize(buffer, delegate)
				super(buffer)
				
				@delegate = delegate
				@level = 0
			end

			def parse!
				@delegate.begin_parse(self)
				
				until eos?
					start_pos = self.pos

					scan_heading
					scan_paragraph
					scan_code
					scan_newlines

					raise_if_stuck(start_pos)
				end
				
				@delegate.end_parse(self)
			end

			protected

			def scan_newlines
				# Consume all newlines.
				if self.scan(/\n*/)
					@delegate.whitespace(self.matched)
				end
			end

			def scan_heading
				# Match any character data except the open tag character.
				if self.scan(/\s*(\#+)\s*(.*?)\n/)
					level = self[1].length
					
					unless level <= (@level + 1)
						parse_error!("Cannot nest heading more than one level deep at a time!")
					else
						@level = level
					end
					
					text = self[2]
					
					# If the title has a inline code fence, e.g. "# Testing `String`"
					# we only pass along the part in the code fence.
					text = $1 if text =~ /`(.*?)`/
					
					@delegate.heading(level, text)
				end
			end
			
			PARAGRAPH_LINE = /([^\s#].*?\n)/
			
			def scan_paragraph
				if self.scan(PARAGRAPH_LINE)
					lines = [self[1]]
					
					while self.scan(PARAGRAPH_LINE)
						lines << self[1]
					end
					
					@delegate.paragraph(lines)
				end
			end
			
			CODE_LINE = /\t(.*?\n)/
			
			def scan_code
				if self.scan(CODE_LINE)
					lines = [self[1]]
					
					while self.scan(CODE_LINE)
						lines << self[1]
					end
					
					@delegate.code(lines)
				end
			end
		end
	end
end
