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
  spec.required_ruby_version = '>= 3.2.2'

  spec.add_dependency 'colorize', '>= 1.1.0'
  spec.add_dependency 'facets', '>= 3.1.0'
  spec.add_dependency 'github-linguist', '>= 7.28.0'
  spec.add_dependency 'pkg-config', '>= 1.5.6'
  spec.add_dependency 'spdx', '>= 4.1.3'
  spec.add_dependency 'thor', '>= 1.2.2'
  spec.add_dependency 'thor-zsh_completion', '>= 0.1.10'

  spec.add_development_dependency 'bundler', '>= 2.4.10'
  spec.add_development_dependency 'fasterer', '>= 0.11.0'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rspec', '>= 3.13.0'
  spec.add_development_dependency 'rubocop', '>= 1.69.2'
  spec.add_development_dependency 'rubocop-performance', '>= 1.20.2'
  spec.add_development_dependency 'simplecov-cobertura', '>= 2.1.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
