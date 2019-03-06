
require_relative 'lib/guard/falcon/version'

Gem::Specification.new do |spec|
	spec.name          = "guard-falcon"
	spec.version       = Guard::Falcon::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = "A guard plugin to run an instance of the falcon web server."
	spec.homepage      = "https://github.com/socketry/guard-falcon"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency("falcon", "~> 0.19")
	
	spec.add_dependency("guard")
	spec.add_dependency("guard-compat", "~> 1.2")
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rspec", "~> 3.6"
	spec.add_development_dependency "rake"
end
