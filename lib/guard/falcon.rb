# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require "guard"
require "guard/plugin"

require "falcon/command"

module Guard
	class Falcon < Plugin
		attr_reader :options, :runner

		def self.default_env
			ENV.fetch('RACK_ENV', 'development')
		end

		DEFAULT_OPTIONS = {
			:bind => ["tcp://localhost:9000"],
			:environment => default_env,
		}

		def initialize(**options)
			super
			
			@serve = ::Falcon::Command::Serve.new
			@serve.options.update(options)
			
			@container = nil
		end

		def start
			@container = @serve.run
		end

		def reload
			stop
			start
		end

		def stop
			@container.stop
		end

		def run_on_change(paths)
			reload
		end
	end
end