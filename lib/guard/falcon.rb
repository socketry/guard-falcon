# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.

require_relative 'falcon/plugin'

module Guard
	module Falcon
		def self.new(*arguments, **options)
			Plugin.new(*arguments, **options)
		end
	end
end
