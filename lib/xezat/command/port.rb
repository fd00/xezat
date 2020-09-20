# frozen_string_literal: true

require 'fileutils'
require 'xezat'
require 'xezat/config'
require 'xezat/variables'

module Xezat
  class NoPortDirectoryError < StandardError
  end

  module Command
    class Port
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        Xezat.logger.debug('Start porting')
        vars = variables(@cygport)
        d = File.expand_path(File.join(get_port_directory(@options), vars[:PN]))
        cygport = File.expand_path(File.join(vars[:top], @cygport))
        readme = File.expand_path(File.join(vars[:C], 'README'))
        src_patch = File.expand_path(File.join(vars[:patchdir], "#{vars[:PF]}.src.patch"))

        fuo = {
          noop: @options[:noop],
          verbose: @options[:noop] || @options[:verbose]
        }

        FileUtils.mkdir_p(d, fuo)
        FileUtils.cp(cygport, d, fuo)
        FileUtils.cp(readme, d, fuo)
        FileUtils.cp(src_patch, d, fuo) unless FileTest.zero?(src_patch)
        Xezat.logger.debug('End porting')
      end

      def get_port_directory(options)
        conf = config(options[:config])
        port_dir = conf['xezat']['portdir'] || options[:portdir]
        raise NoPortDirectoryError if port_dir.nil?

        Xezat.logger.debug("Port directory: #{port_dir}")
        port_dir
      end
    end
  end
end
