# frozen_string_literal: true

require 'bundler/setup'
require 'xezat'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

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
  self.__send__(:remove_const, :LOG)
  const_set(:LOG, Logger.new('/dev/null'))
end
