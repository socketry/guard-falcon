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
require 'rack/server'

require 'async/container/forked'
require 'falcon/server'

module Guard
	module Falcon
		class Controller < Plugin
			DEFAULT_OPTIONS = {
				port: 9292,
				host: 'localhost',
				config: 'config.ru',
			}

			def initialize(**options)
				super
				
				@options = DEFAULT_OPTIONS.merge(options)
				@container = nil
			end

			# As discussed in https://github.com/guard/guard/issues/713
			def logger
				Compat::UI
			end

			def run_server
				begin
					app, options = Rack::Builder.parse_file(@options[:config])
				rescue
					logger.error "Failed to load #{@options[:config]}: #{$!}"
					logger.error $!.backtrace
				end
				
				server_address = Async::IO::Endpoint.tcp(@options[:host], @options[:port], reuse_port: true)
				
				logger.info("Starting Falcon HTTP server on #{server_address}.")
				
				Async::Container::Forked.new(concurrency: 2) do
					server = ::Falcon::Server.new(app, [server_address])
					
					Process.setproctitle "Guard::Falcon HTTP Server #{@options[:bind]}"
					
					server.run
				end
			end

			def start
				@container = run_server
			end

			def running?
				!@container.nil?
			end

			def reload
				stop
				start
			end

			def stop
				if @container
					@container.stop
					@container = nil
				end
			end

			def run_on_change(paths)
				reload
			end
		end
	end
end
