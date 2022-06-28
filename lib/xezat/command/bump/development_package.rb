# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/compiler'
require 'xezat/command/bump/language'
require 'xezat/command/bump/tool'

module Xezat
  module Command
    class Bump
      def get_development_packages(variables, packages, runtimes, pkg2files)
        Xezat.logger.debug('  Collect development packages')
        compilers = get_compilers(get_languages(variables[:S]), variables)
        tools = get_tools(variables)
        build_requires = variables[:BUILD_REQUIRES].nil? ? [] : variables[:BUILD_REQUIRES].split.map(&:to_sym)
        development_packages = (compilers + tools + build_requires + [:cygport]).uniq

        resolve_development_package(development_packages)

        # Check gcc-gfortran
        if runtimes.grep(/^libgfortran/).empty?
          delete_fortran = true
          pkg2files.each_value do |files|
            delete_fortran = false unless files.grep(/\.mod$/).empty?
          end
          development_packages.delete(:'gcc-fortran') if delete_fortran
        end

        development_packages.sort!

        development_packages.map! do |package|
          pkg = packages[package]
          raise "Package #{package} is not installed in your system" if pkg.nil?

          pkg
        end
      end

      def resolve_development_package(development_packages)
        # Check libssl duplication
        development_packages.delete(:'libssl-devel') if development_packages.include?(:'libssl1.0-devel')

        # Check lua duplication
        development_packages.delete(:lua) if development_packages.include?(:'lua5.1-devel')
        development_packages.delete(:lua) if development_packages.include?(:'luajit-devel')
      end
    end
  end
end
