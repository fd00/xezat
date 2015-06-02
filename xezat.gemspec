# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xezat/version'

Gem::Specification.new do |spec|
  spec.name          = "xezat"
  spec.version       = Xezat::VERSION
  spec.authors       = ["fd0"]
  spec.email         = ["booleanlabel@gmail.com"]
  spec.summary       = 'Complement of cygport'
  spec.description   = 'Complement of cygport '
  spec.homepage      = "https://github.com/fd00/xezat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "facets", "~> 3.0"
  spec.add_runtime_dependency "github-linguist", "~> 4.3"
  spec.add_runtime_dependency "inifile", "~> 3.0"
  spec.add_runtime_dependency "logger-colors", "~> 1.0"
  spec.add_runtime_dependency "mercenary", "~> 0.3.5"
  spec.add_runtime_dependency "string-scrub", "~> 0.0.5"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.0.9"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
end
