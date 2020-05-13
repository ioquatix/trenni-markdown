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

require_relative '../markdown'
require_relative 'generators'

require 'samovar'

module Trenni
	module Markdown
		module Command
			class Generate < Samovar::Command
				options do
					option "-g/--generator <name>", "The class to use for the conversion process.", default: 'Markup'
				end
				
				many :paths, "The paths to convert."
				
				def generator_class
					Trenni::Markdown::Generators.const_get(@options[:generator])
				end
				
				def call
					@paths.each do |path|
						buffer = Trenni::FileBuffer.new(path)
						generator = generator_class.new
						
						Trenni::Markdown::Parser.new(buffer, generator).parse!
					end
				end
			end
			
			class Top < Samovar::Command
				self.description = "Convert markdown into other formats."
				
				nested :command, {
					'generate' => Generate
				}
				
				def call
					if @command
						@command.call
					else
						print_usage
					end
				end
			end
		end
	end
end
