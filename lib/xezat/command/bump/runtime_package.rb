# frozen_string_literal: true

require 'xezat'
require 'xezat/command/bump/cygport_dep'
require 'xezat/variables'

module Xezat
  module Command
    class Bump
      def get_runtime_packages(vars, cygport)
        Xezat.logger.debug('  Collect runtime packages from cygport dep')
        result = invoke_cygport_dep(vars, cygport)
        result.gsub(/^.*\*\*\*.*$/, '').split($INPUT_RECORD_SEPARATOR).map(&:lstrip)
      end
    end
  end
end
