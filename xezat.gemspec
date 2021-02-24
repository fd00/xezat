# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xezat/version'

Gem::Specification.new do |spec|
  spec.name          = 'xezat'
  spec.version       = Xezat::VERSION
  spec.authors       = ['Daisuke Fujimura (fd0)']
  spec.email         = ['booleanlabel@gmail.com']

  spec.summary       = 'xezat helps you win at cygport.'
  spec.description   = 'xezat helps you win at cygport.'
  spec.homepage      = 'https://github.com/fd00/xezat'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6.4'

  spec.add_runtime_dependency 'facets', '>= 3.1.0'
  spec.add_runtime_dependency 'github-linguist', '>= 7.13.0'
  spec.add_runtime_dependency 'pkg-config', '>= 1.4.5'
  spec.add_runtime_dependency 'thor', '>= 0.20.3'
  spec.add_runtime_dependency 'thor-zsh_completion', '>= 0.1.9'

  spec.add_development_dependency 'bundler', '>= 1.15.3'
  spec.add_development_dependency 'fasterer', '>= 0.9.0'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rspec', '>= 3.9.0'
  spec.add_development_dependency 'rspec_junit_formatter', '<= 0.4.1'
  spec.add_development_dependency 'rubocop', '>= 1.10.0'
  spec.add_development_dependency 'rubocop-performance', '>= 1.9.2'
  spec.add_development_dependency 'simplecov', '>= 0.21.2'
end
