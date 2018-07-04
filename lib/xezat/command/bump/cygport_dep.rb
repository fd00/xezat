# frozen_string_literal: true

require 'open3'
require 'xezat'

module Xezat
  module Command
    class Bump
      def invoke_cygport_dep(cygport)
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3(command.join(' '))
        raise CygportProcessError, error unless status.success?
        result
      end
    end
  end
end
