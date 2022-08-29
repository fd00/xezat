# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/cygport_dep'
require 'xezat/variables'

module Xezat
  module Command
    class Bump
      def get_runtime_packages(variables, pkgs, cygport)
        Xezat.logger.debug('  Collect runtime packages from cygport dep')
        result = invoke_cygport_dep(variables, cygport)
        runtime_packages = result.gsub(/^.*\*\*\*.*$/, '').split($INPUT_RECORD_SEPARATOR).map(&:lstrip)
        build_requires = variables[:BUILD_REQUIRES].nil? ? [] : variables[:BUILD_REQUIRES].split.map(&:to_sym)
        runtime_packages.delete(pkgs[:'libssl-devel']) if build_requires.include?(:'libssl1.0-devel')
        runtime_packages.map! { |pkg| pkg == 'python3' ? pkgs[:python39] : pkg }
        variables[:REQUIRES]&.split&.each do |req|
          runtime_packages << pkgs[req.to_sym]
        end
        runtime_packages.sort.uniq
      end
    end
  end
end
