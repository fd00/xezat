# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'facets/string/word_wrap'
require 'open3'
require 'uri'
require 'yaml'
require 'xezat'

module Xezat
  def variables(cygport)
    cygport_dir = File.dirname(File.absolute_path(cygport))
    cache_file = File.expand_path(File.join(cygport_dir, File.basename(cygport, '.cygport') + '.cache.yml'))

    Xezat.logger.debug('Extract variables')

    if File.exist?(cache_file) && File.ctime(cache_file) > File.ctime(cygport)
      Xezat.logger.debug('  Read cache for variables')
      return YAML.safe_load(File.open(cache_file), [Symbol]).each_value do |v|
        v.strip! if v.respond_to?(:strip)
      end
    end

    command = ['bash', File.expand_path(File.join(DATA_DIR, 'show_cygport_variable.sh')), cygport]
    result, error, status = Open3.capture3(command.join(' '))
    raise CygportProcessError, error unless status.success?

    result.gsub!(/^.*\*\*\*.*$/, '')

    variables = YAML.safe_load(result, [Symbol]).each_value do |v|
      v.strip! if v.respond_to?(:strip)
    end
    variables[:DESCRIPTION].word_wrap!(79)

    File.atomic_write(cache_file) do |f|
      Xezat.logger.debug('  Write cache for variables')
      f.write(YAML.dump(variables))
    end

    variables
  end
end
