# frozen_string_literal: true

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
        vars = variables(@cygport)
        generate_pkg_config(vars, @options)

        if vars[:_cmake_CYGCLASS_]
          append_commands_to_cmakelists(vars)
        else
          append_commands_to_autotools(vars)
        end
      end

      def generate_pkg_config(variables, options)
        srcdir = variables[:CYGCONF_SOURCE] || variables[:CYGCMAKE_SOURCE] || variables[:S]
        pn = variables[:PN]
        pc = File.expand_path(File.join(srcdir, "#{pn}.pc.in"))
        raise UnregeneratableConfigurationError, "#{pn}.pc.in already exists" if File.exist?(pc) && !options['overwrite']

        File.atomic_write(pc) do |f|
          f.write(get_pkg_config(variables))
        end
      end

      def get_pkg_config(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'pkgconfig.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end

      def append_commands_to_cmakelists(variables)
        srcdir = variables[:CYGCMAKE_SOURCE] || variables[:S]
        cmakelists = File.expand_path(File.join(srcdir, 'CMakeLists.txt'))
        return if %r!DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig!.match?(File.read(cmakelists))

        File.atomic_open(cmakelists, 'a') do |f|
          f.write(get_cmakelists(variables))
        end
      end

      def get_cmakelists(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'cmake.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end

      def append_commands_to_autotools(variables)
        srcdir = variables[:CYGCONF_SOURCE] || variables[:S]
        pn = variables[:PN]
        configure_ac = File.expand_path(File.join(srcdir, 'configure.ac'))
        configure_ac = File.expand_path(File.join(srcdir, 'configure.in')) unless File.exist?(configure_ac)
        raise AutotoolsFileNotFoundError unless File.exist?(configure_ac)

        original_ac = File.read(configure_ac)

        return if /#{pn}.pc/.match?(original_ac)

        original_ac.gsub!(/(AC_CONFIG_FILES\(\[)/, "\\1#{"#{pn}.pc "}")
        File.atomic_write(configure_ac) do |fa|
          fa.write(original_ac)

          makefile_am = File.expand_path(File.join(srcdir, 'Makefile.am'))
          raise AutotoolsFileNotFoundError unless File.exist?(makefile_am)

          break if /pkgconfig_DATA/.match?(File.read(makefile_am))

          commands_am = File.read(File.expand_path(File.join(TEMPLATE_DIR, 'Makefile.am')))
          File.atomic_open(makefile_am, 'a') do |fm|
            fm.write(commands_am)
          end
        end
      end
    end
  end
end
