# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/compiler'
require 'xezat/command/bump/language'
require 'xezat/command/bump/tool'

module Xezat
  module Command
    class Bump
      def get_development_packages(variables, packages)
        LOG.debug('Collect development packages')
        compilers = get_compilers(get_languages(variables[:S]), variables)
        tools = get_tools(variables)
        development_packages = (compilers + tools + [:cygport]).uniq.sort
        development_packages.map! do |package|
          packages[package] || ''
        end
      end
    end
  end
end
