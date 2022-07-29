# frozen_string_literal: true

require 'English'
require 'etc'
require 'facets/file/atomic_write'
require 'facets/string/word_wrap'
require 'open3'
require 'uri'
require 'yaml'
require 'xezat'

module Xezat
  def variables(cygport)
    cygport_dir = File.dirname(File.absolute_path(cygport))
    cache_file = File.expand_path(File.join(cygport_dir, "#{File.basename(cygport, '.cygport')}.#{Etc.uname[:machine]}.yml"))

    Xezat.logger.debug('  Extract variables')

    if File.exist?(cache_file) && File.ctime(cache_file) > File.ctime(cygport)
      Xezat.logger.debug('    Read cache for variables')
      return YAML.safe_load(File.open(cache_file), [Symbol]).each do |k, v|
        v.strip! if v.respond_to?(:strip) && k != :DESCRIPTION
      end
    end

    command = ['bash', File.expand_path(File.join(DATA_DIR, 'var2yaml.sh')), cygport]
    result, error, status = Open3.capture3(command.join(' '))
    raise CygportProcessError, error unless status.success?

    result.gsub!(/^.*\*\*\*.*$/, '')

    begin
      variables = YAML.safe_load(result, [Symbol]).each_value do |v|
        v.strip! if v.respond_to?(:strip)
      end
    rescue Psych::SyntaxError => e
      print_yaml(result)
      raise e
    end

    variables[:DESCRIPTION].word_wrap!(79)

    File.atomic_write(cache_file) do |f|
      Xezat.logger.debug('    Write cache for variables')
      f.write(YAML.dump(variables))
    end

    variables
  end

  def print_yaml(result)
    lineno = 1
    result.split($INPUT_RECORD_SEPARATOR).each do |line|
      printf '%<lineno>5d | %<line>s%<ls>s', lineno: lineno, line: line, ls: $INPUT_RECORD_SEPARATOR
      lineno += 1
    end
  end
end
