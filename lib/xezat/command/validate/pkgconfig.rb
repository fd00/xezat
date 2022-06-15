# frozen_string_literal: true

require 'pkg-config'
require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_pkgconfig(variables)
        pkgconfig_path = File.join(variables[:D], 'usr', 'lib', 'pkgconfig')
        PKGConfig.add_path(pkgconfig_path)
        Dir.glob('*.pc', 0, base: pkgconfig_path).each do |pc|
          basename = File.basename(pc, '.pc')
          Xezat.logger.debug("    #{basename}.pc found")
          modversion = PKGConfig.modversion(basename)
          Xezat.logger.debug("      modversion = #{modversion}")
          pv = variables[:PV][0].gsub(/\+.+$/, '')
          Xezat.logger.error("        modversion differs from $PN = #{pv}") unless modversion == pv
          Xezat.logger.debug("      cflags = #{PKGConfig.cflags(basename)}")
          libs = PKGConfig.libs(basename)
          Xezat.logger.debug("      libs = #{libs}")
          validate_libs(variables, libs)
        end
      end
    end
  end
end
