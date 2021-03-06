# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tact/version'

Gem::Specification.new do |spec|
  spec.name          = "tact"
  spec.version       = Tact::VERSION
  spec.authors       = ["Matthew Todd"]
  spec.email         = ["matthew@matthewtodd.org"]
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "google-api-client"
  spec.add_runtime_dependency "json", "~> 1.7.7"
  spec.add_runtime_dependency "rb-appscript"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
