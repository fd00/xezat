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

        Xezat.logger.debug('  Validate .cygport')
        validate_cygport(@cygport)

        Xezat.logger.debug('  Validate category')
        validate_category(vars[:CATEGORY])

        Xezat.logger.debug('  Validate homepage')
        validate_homepage(vars[:HOMEPAGE])

        Xezat.logger.debug('  Validate *.pc')
        validate_pkgconfig(vars)

        Xezat.logger.debug('End validating')
      end

      def validate_cygport(cygport)
        original_string = File.read(cygport)
        stripped_string = original_string.gsub(/^\xEF\xBB\xBF/, '')
        Xezat.logger.error('    .cygport contains BOM') unless original_string == stripped_string
      end

      def validate_category(category)
        categories_file = File.expand_path(File.join(DATA_DIR, 'categories.yaml'))
        Xezat.logger.error("    Category is invalid : #{category}") unless YAML.safe_load(File.open(categories_file), [Symbol]).include?(category.downcase)
      end

      def validate_homepage(homepage)
        response = Net::HTTP.get_response(URI.parse(homepage))
        code = response.code
        if code == '200'
          Xezat.logger.debug("    code = #{response.code}")
        else
          Xezat.logger.error("    code = #{response.code}")
        end
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
        lib_dirs = [File.join(variables[:D], '/usr/lib'), '/usr/lib', '/usr/lib/w32api', '/usr/lib/gcc/x86_64-pc-cygwin/10']
        libs.split do |option|
          if option.start_with?('-l')
            lib_name = option[2, 255] # Assume file length limit
            found = false
            lib_dirs.each do |dir|
              archive_path = File.join(dir, "lib#{lib_name}.dll.a")
              if File.exist?(archive_path)
                Xezat.logger.debug("        #{lib_name} -> #{archive_path.gsub(variables[:D], '$D')}")
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
