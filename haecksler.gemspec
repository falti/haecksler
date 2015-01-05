# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'haecksler/version'

Gem::Specification.new do |spec|
  spec.name          = "haecksler"
  spec.version       = Haecksler::VERSION
  spec.authors       = ["Frank Falkenberg"]
  spec.email         = ["faltibrain@gmail.com"]
  spec.summary       = %q{Library to parse fixed-length files}
  spec.description   = %q{Haecksler is the German word for a wood chipper, the library processes fixed-length files}
  spec.homepage      = "https://github.com/falti/haecksler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "rspec-collection_matchers"
end
