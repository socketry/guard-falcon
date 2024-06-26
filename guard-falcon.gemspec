# frozen_string_literal: true

require_relative "lib/guard/falcon/version"

Gem::Specification.new do |spec|
	spec.name = "guard-falcon"
	spec.version = Guard::Falcon::VERSION
	
	spec.summary = "A guard plugin to run an instance of the falcon web server."
	spec.authors = ["Samuel Williams", "Huba Nagy", "Olle Jonsson"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/guard-falcon"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/socketry/guard-falcon.git",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "async-container", "~> 0.16"
	spec.add_dependency "console", "~> 1.0"
	spec.add_dependency "falcon", "~> 0.35"
	spec.add_dependency "guard"
	spec.add_dependency "guard-compat", "~> 1.2"
end
