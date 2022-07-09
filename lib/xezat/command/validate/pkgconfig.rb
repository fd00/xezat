# frozen_string_literal: true

require 'pkg-config'
require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_pkgconfig(variables, gcc_version)
        pkgconfig_path = File.join(variables[:D], 'usr', 'lib', 'pkgconfig')
        PKGConfig.add_path(pkgconfig_path)
        Dir.glob('*.pc', 0, base: pkgconfig_path).each do |pc|
          Xezat.logger.debug("    #{pc} found")
          basename = File.basename(pc, '.pc')

          modversion = PKGConfig.modversion(basename)
          Xezat.logger.debug("      modversion = #{modversion}")
          pv = variables[:PV][0].gsub(/\+.+$/, '')
          Xezat.logger.error("        modversion differs from $PN = #{pv}") unless modversion == pv

          prefix = PKGConfig.variable(basename, 'prefix')
          if prefix.nil? || prefix.empty? || prefix.eql?('/usr')
            Xezat.logger.debug("      prefix = #{prefix}")
          else
            Xezat.logger.warn("       prefix = #{prefix} (not standard)")
          end

          Xezat.logger.debug("      cflags = #{PKGConfig.cflags(basename)}")

          libs = PKGConfig.libs(basename)
          Xezat.logger.debug("      libs = #{libs}")
          validate_libs(variables, libs, gcc_version)
        end
      end
    end
  end
end
