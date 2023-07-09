# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov-cobertura'
require 'xezat'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true

  config.order = :random
end

# suppress log on test
module Xezat
  Xezat.logger = Logger.new('/dev/null')
end

SimpleCov.start do
  add_filter '/spec/'
  coverage_dir 'tmp/coverage'
end

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter if ENV['CI']
