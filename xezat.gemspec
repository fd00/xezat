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
  spec.required_ruby_version = '>= 2.3.6'

  spec.add_runtime_dependency 'facets', '>= 3.1.0'
  spec.add_runtime_dependency 'github-linguist', '>= 7.1.3'
  spec.add_runtime_dependency 'inifile', '>= 3.0.0'
  spec.add_runtime_dependency 'io-console', '>= 0.4.6'
  spec.add_runtime_dependency 'thor', '>= 0.19.4'
  spec.add_runtime_dependency 'thor-zsh_completion', '>= 0.1.5'

  spec.add_development_dependency 'bundler', '>= 1.15.3'
  spec.add_development_dependency 'coveralls', '>= 0.8.22'
  spec.add_development_dependency 'fasterer', '>= 0.4.1'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'rspec', '>= 3.8.0'
  spec.add_development_dependency 'rspec_junit_formatter', '<= 0.4.1'
  spec.add_development_dependency 'rubocop', '>= 0.62'
end
