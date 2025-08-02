# frozen_string_literal: true

require 'English'
require 'etc'
require 'facets/file/atomic_write'
require 'yaml'
require 'xezat'
require 'xezat/bashvar'

module Xezat
  def variables(cygport)
    cygport_dir = File.dirname(File.absolute_path(cygport))
    cache_file = File.expand_path(File.join(cygport_dir, "#{File.basename(cygport, '.cygport')}.#{Etc.uname[:machine]}.yml"))

    Xezat.logger.debug('  Extract variables')

    if File.exist?(cache_file) && File.ctime(cache_file) > File.ctime(cygport)
      Xezat.logger.debug('    Read cache for variables')
      return YAML.safe_load(File.open(cache_file), symbolize_names: true, permitted_classes: [Symbol]).each do |k, v|
        v.strip! if v.respond_to?(:strip) && k != :DESCRIPTION
      end
    end

    vars = bashvar(cygport)

    File.atomic_write(cache_file) do |f|
      Xezat.logger.debug('    Write cache for variables')
      f.write(YAML.dump(vars))
    end

    vars
  end
end
