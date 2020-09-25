# frozen_string_literal: true

require 'net/http'
require 'pkg-config'
require 'uri'
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

        Xezat.logger.debug('  Validate homepage')
        validate_homepage(vars)

        Xezat.logger.debug('  Validate *.pc')
        validate_pkgconfig(vars)

        Xezat.logger.debug('End validating')
      end

      def validate_homepage(variables)
        response = Net::HTTP.get_response(URI.parse(variables[:HOMEPAGE]))
        Xezat.logger.debug("    code = #{response.code}")
      end

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

      def validate_libs(variables, libs)
        lib_dirs = [File.join(variables[:D], '/usr/lib'), '/usr/lib']
        libs.split do |option|
          if option.start_with?('-l')
            lib_name = option[2, 255] # Assume file length limit
            found = false
            lib_dirs.each do |dir|
              archive_path = File.join(dir, "lib#{lib_name}.dll.a")
              if File.exist?(archive_path)
                Xezat.logger.debug("        #{lib_name} -> #{archive_path}")
                found = true
                break
              end
              static_path = File.join(dir, "lib#{lib_name}.a")
              next unless File.exist?(static_path)

              Xezat.logger.debug("        #{lib_name} -> #{static_path}")
              found = true
              break
            end
            Xezat.logger.error("        #{lib_name} not found") unless found
          end
        end
      end
    end
  end
end
