# frozen_string_literal: true

require 'logger'

module Xezat
  ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  DATA_DIR = File.expand_path(File.join(ROOT_DIR, 'share', 'xezat'))
  REPOSITORY_DIR = File.expand_path(File.join(DATA_DIR, 'repository'))
  TEMPLATE_DIR = File.expand_path(File.join(DATA_DIR, 'template'))
  CONFIG_FILE = File.expand_path(File.join(Dir.home, '.xezat', 'config.yml'))

  class << self
    attr_accessor :logger
  end
  Xezat.logger = Logger.new($stdout)
  Xezat.logger.formatter = proc { |severity, datetime, _progname, message|
    "#{datetime}: [#{severity}] #{message}\n"
  }

  class CygportProcessError < StandardError
  end
end
