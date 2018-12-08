# frozen_string_literal: true

require 'logger'

module Xezat
  ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  DATA_DIR = File.expand_path(File.join(ROOT_DIR, 'share', 'xezat'))
  REPOSITORY_DIR = File.expand_path(File.join(DATA_DIR, 'repository'))
  TEMPLATE_DIR = File.expand_path(File.join(DATA_DIR, 'template'))
  INI_FILE = File.expand_path(File.join(Dir.home, '.xezat'))

  LOG = Logger.new(STDOUT)
  LOG.formatter = proc { |_severity, datetime, _progname, message|
    "#{datetime}: #{message}\n"
  }

  class CygportProcessError < StandardError
  end
end
