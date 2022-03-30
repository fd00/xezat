# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/compiler'
require 'xezat/command/bump/language'
require 'xezat/command/bump/tool'

module Xezat
  module Command
    class Bump
      def get_development_packages(variables, packages, runtimes)
        Xezat.logger.debug('  Collect development packages')
        compilers = get_compilers(get_languages(variables[:S]), variables)
        tools = get_tools(variables)
        build_requires = variables[:BUILD_REQUIRES].nil? ? [] : variables[:BUILD_REQUIRES].split.map(&:to_sym)
        development_packages = (compilers + tools + build_requires + [:cygport]).uniq.sort

        # Check libssl duplication
        development_packages.delete(:'libssl-devel') if development_packages.include?(:'libssl1.0-devel')

        # Check gcc-gfortran
        development_packages.delete(:'gcc-fortran') if runtimes.grep(/^libgfortran/).empty?

        development_packages.map! do |package|
          pkg = packages[package]
          raise "Package #{package} is not installed in your system" if pkg.nil?

          pkg
        end
      end
    end
  end
end
