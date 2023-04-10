# frozen_string_literal: true

require 'English'
require 'facets/file/atomic_open'
require 'facets/file/atomic_write'
require 'xezat/variables'

module Xezat
  class UnregeneratableConfigurationError < StandardError
  end

  class AutotoolsFileNotFoundError < StandardError
  end

  module Generator
    class Pkgconfig
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def generate
        Xezat.logger.debug('Start package config generation')
        vars = variables(@cygport)
        generate_pkg_config(vars, @options)

        if vars[:_cmake_CYGCLASS_]
          append_commands_to_cmakelists(vars, @options)
        else
          append_commands_to_autotools(vars, @options)
        end
        Xezat.logger.debug('End package config generation')
      end

      def generate_pkg_config(variables, options)
        srcdir = variables[:CYGCONF_SOURCE] || variables[:CYGCMAKE_SOURCE] || variables[:S]
        srcdir = File.expand_path(File.join(variables[:S], options['srcdir'])) if options['srcdir']
        Xezat.logger.debug("  srcdir = #{srcdir}")

        pn = variables[:PN]
        pc = File.expand_path(File.join(srcdir, "#{pn}.pc.in"))
        raise UnregeneratableConfigurationError, "#{pn}.pc.in already exists" if File.exist?(pc) && !options['overwrite']

        Xezat.logger.debug('  Generate pc')

        File.atomic_write(pc) do |f|
          f.write(get_pkg_config(variables))
        end
      end

      def get_pkg_config(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'pkgconfig.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end

      def append_commands_to_cmakelists(variables, options)
        srcdir = variables[:CYGCMAKE_SOURCE] || variables[:S]
        srcdir = File.expand_path(File.join(variables[:S], options['srcdir'])) if options['srcdir']
        cmakelists = File.expand_path(File.join(srcdir, 'CMakeLists.txt'))
        if %r!DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig!.match?(File.read(cmakelists))
          Xezat.logger.debug('  Not rewrite CMakeLists.txt')
          return
        end

        Xezat.logger.debug('  Rewrite CMakeLists.txt')

        File.atomic_open(cmakelists, 'a') do |f|
          f.write(get_cmakelists(variables))
        end
      end

      def get_cmakelists(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'cmake.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end

      def append_commands_to_autotools(variables, options)
        srcdir = variables[:CYGCONF_SOURCE] || variables[:S]
        srcdir = File.expand_path(File.join(variables[:S], options['srcdir'])) if options['srcdir']
        pn = variables[:PN]
        configure_ac = File.expand_path(File.join(srcdir, 'configure.ac'))
        configure_ac = File.expand_path(File.join(srcdir, 'configure.in')) unless File.exist?(configure_ac)
        raise AutotoolsFileNotFoundError unless File.exist?(configure_ac)

        original_ac = File.read(configure_ac)

        if /#{pn}.pc/.match?(original_ac)
          Xezat.logger.debug("  Not rewrite #{configure_ac}")
          return
        end

        rewritten_ac = original_ac.gsub(/^AC_OUTPUT$/, "AC_CONFIG_FILES([#{pn}.pc])#{$INPUT_RECORD_SEPARATOR}AC_OUTPUT")

        File.atomic_open(configure_ac, 'w') do |fa|
          fa.write(rewritten_ac)

          makefile_am = File.expand_path(File.join(srcdir, 'Makefile.am'))
          raise AutotoolsFileNotFoundError unless File.exist?(makefile_am)

          if File.read(makefile_am).include?('pkgconfig_DATA')
            Xezat.logger.debug("  Not rewrite #{makefile_am}")
            break
          end

          commands_am = File.read(File.expand_path(File.join(TEMPLATE_DIR, 'Makefile.am')))
          File.atomic_open(makefile_am, 'a') do |fm|
            fm.write(commands_am)
          end
        end
      end
    end
  end
end
