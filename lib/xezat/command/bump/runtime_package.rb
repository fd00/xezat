# frozen_string_literal: true

require 'xezat'
require 'xezat/variables'

module Xezat
  module Command
    class Bump
      def get_runtime_packages(cygport)
        LOG.debug('Collect runtime packages from cygport dep')
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3(command.join(' '))
        raise CygportProcessError, error unless status.success?
        result.gsub!(/^.*\*\*\*.*$/, '')
        result.split($INPUT_RECORD_SEPARATOR).map!(&:lstrip)
      end
    end
  end
end
