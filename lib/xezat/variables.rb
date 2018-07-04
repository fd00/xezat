# frozen_string_literal: true

require 'facets/string/word_wrap'
require 'open3'
require 'uri'
require 'yaml'
require 'xezat'

module Xezat
  def variables(cygport)
    LOG.debug('Extract variables')
    command = ['bash', File.expand_path(File.join(DATA_DIR, 'show_cygport_variable.sh')), cygport]
    result, error, status = Open3.capture3(command.join(' '))
    raise CygportProcessError, error unless status.success?
    result.gsub!(/^.*\*\*\*.*$/, '')

    variables = YAML.safe_load(result, [Symbol]).each_value do |v|
      v.strip! if v.respond_to?(:strip)
    end
    variables[:DESCRIPTION].word_wrap!(79)
    variables
  end
end
