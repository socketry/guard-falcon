# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.
# Copyright, 2018-2019, by Huba Nagy.

require 'guard/compat/plugin'

require 'falcon'
require 'falcon/environment/rackup'
require 'falcon/environment/server'
require 'async/service'
require 'console'

module Guard
	module Falcon
		class Plugin < Guard::Plugin
			def self.default_environment(**options)
				Async::Service::Environment.new(::Falcon::Environment::Server).with(
					::Falcon::Environment::Rackup,
					**options
				)
			end
			
			def initialize(**options)
				super
				
				options[:root] ||= Dir.pwd
				options[:name] ||= "falcon"
				
				if paths = options[:paths]
					@configuration = Async::Service::Configuration.load(paths)
				else
					@configuration = Async::Service::Configuration.new
					
					# Compatibility
					if rackup_path = options.delete(:config)
						warn "The :config option is deprecated, please use :rackup_path instead.", uplevel: 1
						options[:rackup_path] = rackup_path
					end
					
					@configuration.add(self.class.default_environment(**options))
				end
				
				@controller = ::Async::Service::Controller.new(@configuration.services.to_a)
			end
			
			def start
				@controller.start
			end
			
			def running?
				@controller.running?
			end
			
			def reload
				@controller.restart
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
