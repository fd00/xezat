# frozen_string_literal: true

require 'find'
require 'open3'
require 'xezat'

module Xezat
  module Command
    class Bump
      def invoke_cygport_dep(vars, cygport)
        additional_path = Find.find(vars[:D]).select do |file|
          file.end_with?('.exe', '.dll')
        end.map do |file|
          File.dirname(file)
        end.sort.uniq.join(':')
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3({ 'PATH' => ENV['PATH'] + ':' + additional_path }, command.join(' '))
        raise CygportProcessError, error unless status.success?

        result
      end
    end
  end
end
