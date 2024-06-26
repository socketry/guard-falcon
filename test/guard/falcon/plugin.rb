# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.

require 'guard/falcon'
require 'guard/compat/test/helper'
require 'guard/falcon/plugin'

describe Guard::Falcon::Plugin do
	let(:rackup_path) {File.join(__dir__, 'config.ru')}
	
	let(:plugin) {subject.new(rackup_path: rackup_path)}
	
	it "should start server" do
		plugin.start
		
		expect(plugin).to be(:running?)
		
		plugin.stop
		
		expect(plugin).not.to be(:running?)
	end
end
