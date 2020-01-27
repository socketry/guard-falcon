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

require 'guard/compat/plugin'

require 'rack/builder'

require 'async/logger'
require 'async/container'

require 'falcon/server'
require 'falcon/endpoint'
require 'falcon/controller/serve'

module Guard
	module Falcon
		class Plugin < Guard::Plugin
			DEFAULT_OPTIONS = {
				config: 'config.ru',
				count: 1,
				verbose: false,
			}
			
			def initialize(**options)
				super
				
				@options = DEFAULT_OPTIONS.merge(options)
				
				@endpoint = nil
				
				@controller = ::Falcon::Controller::Serve.new(self)
			end
			
			def container_class
				Async::Container::Threaded
			end
			
			def container_options
				{}
			end
			
			private def build_endpoint
				# Support existing use cases where only port: is specified.
				if @options[:endpoint]
					return @options[:endpoint]
				else
					url = @options.fetch(:url, "https://localhost")
					port = @options.fetch(:port, 9292)
					
					return ::Falcon::Endpoint.parse(url, port: port)
				end
			end
			
			def endpoint
				@endpoint ||= build_endpoint
			end
			
			def load_app
				rack_app, options = Rack::Builder.parse_file(@options[:config])
				
				return ::Falcon::Server.middleware(rack_app, verbose: @options[:verbose]), options
			end
			
			# As discussed in https://github.com/guard/guard/issues/713
			def logger
				Async.logger
			end
			
			def start
				@controller.start
			end
			
			def running?
				@controller.running?
			end
			
			def reload
				@controller.reload
			end
			
			def stop
				@controller.stop
			end
			
			def run_on_change(paths)
				reload
			end
		end
	end
end
