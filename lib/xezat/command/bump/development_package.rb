# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/compiler'
require 'xezat/command/bump/language'
require 'xezat/command/bump/tool'

module Xezat
  module Command
    class Bump
      def get_development_packages(variables, packages)
        Xezat.logger.debug('  Collect development packages')
        compilers = get_compilers(get_languages(variables[:S]), variables)
        tools = get_tools(variables)
        build_requires = variables[:BUILD_REQUIRES].nil? ? [] : variables[:BUILD_REQUIRES].split.map(&:to_sym)
        development_packages = (compilers + tools + build_requires + [:cygport]).uniq.sort
        development_packages.delete(:'libssl-devel') if development_packages.include?(:'libssl1.0-devel')
        development_packages.map! do |package|
          packages[package] || ''
        end
      end
    end
  end
end
