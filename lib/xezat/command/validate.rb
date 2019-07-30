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
        PKGConfig.add_path(File.join(variables[:D], 'usr', 'lib', 'pkgconfig'))
        pn = variables[:PN]
        if PKGConfig.exist?(pn)
          Xezat.logger.debug("  #{pn}.pc found")
          modversion = PKGConfig.modversion(pn)
          Xezat.logger.debug("    modversion = #{modversion}")
          pv = variables[:PV][0]
          Xezat.logger.error("    modversion differs from $PN = #{pv}") unless modversion == pv
        else
          Xezat.logger.debug("  #{pn}.pc not found")
        end
      end
    end
  end
end
