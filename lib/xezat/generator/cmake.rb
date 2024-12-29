# frozen_string_literal: true

require 'xezat/generator'

module Xezat
  module Generator
    class CMake
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def generate
        Xezat.logger.debug('Start CMakeLists.txt generation')
        vars = variables(@cygport)
        generate_cmakelists(vars, @options)
        Xezat.logger.debug('End CMakeLists.txt generation')
      end

      def generate_cmakelists(variables, options)
        srcdir = variables[:CYGCONF_SOURCE] || variables[:CYGCMAKE_SOURCE] || variables[:S]
        srcdir = File.expand_path(File.join(variables[:S], options['srcdir'])) if options['srcdir']
        Xezat.logger.debug("  srcdir = #{srcdir}")

        cmakelists = File.expand_path(File.join(srcdir, 'CMakeLists.txt'))
        raise UnregeneratableConfigurationError, 'CMakeLists.txt already exists' if File.exist?(cmakelists) && !options['overwrite']

        Xezat.logger.debug('  Generate CMakeLists.txt')

        File.atomic_write(cmakelists) do |f|
          f.write(get_cmakelists(variables))
        end
      end

      def get_cmakelists(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'cmake', 'cmake.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end
    end
  end
end
