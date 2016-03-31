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
		module Generators
			class UnitTest < Generator
				def initialize
					super('// ')
				end
				
				def namespace(level, name)
					# C++17 might help us avoid this mess :(
					parts = name.split(/::/)
					parts.collect!{|part| "namespace #{part} {"}
					
					nest(level, 
						parts.join(' ') + "\n", 
						'}' * parts.count + "\n"
					)
				end
				
				def suite(level, name)
					nest(level,
						"Unit::Test #{name.gsub(/\s/, '')}Suite = {\n",
						"};\n"
					)
				end
				
				def test(level, name)
					nest(level,
						"{\"#{name}\",\n",
						"},\n"
					)
					
					nest(level+1,
						"[](UnitTest::Examiner & examiner) {",
						"}\n"
					)
				end
				
				def heading(level, text)
					case level
					when 1 then namespace(level, text)
					when 2 then suite(level, text)
					when 3 then test(level, text)
					end
				end
			end
		end
	end
end
