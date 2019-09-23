# frozen_string_literal: true

require 'pkg-config'
require 'xezat/variables'

module Xezat
  module Command
    class Validate
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        Xezat.logger.debug('Start validating')
        vars = variables(@cygport)
        validate_pkgconfig(vars)
        Xezat.logger.debug('End validating')
      end

      def validate_pkgconfig(variables)
        pkgconfig_path = File.join(variables[:D], 'usr', 'lib', 'pkgconfig')
        PKGConfig.add_path(pkgconfig_path)
        Dir.glob('*.pc', 0, base: pkgconfig_path).each do |pc|
          basename = File.basename(pc, '.pc')
          Xezat.logger.debug("  #{basename}.pc found")
          modversion = PKGConfig.modversion(basename)
          Xezat.logger.debug("    modversion = #{modversion}")
          pv = variables[:PV][0]
          Xezat.logger.error("      modversion differs from $PN = #{pv}") unless modversion == pv
          Xezat.logger.debug("    cflags = #{PKGConfig.cflags(basename)}")
          Xezat.logger.debug("    libs = #{PKGConfig.libs(basename)}")
        end
      end
    end
  end
end
