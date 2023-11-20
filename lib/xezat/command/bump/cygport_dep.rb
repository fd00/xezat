# frozen_string_literal: true

require 'find'
require 'open3'
require 'xezat'

module Xezat
  module Command
    class Bump
      def invoke_cygport_dep(variables, cygport)
        candidate_files = Find.find(variables[:D]).select do |file|
          file.end_with?('.exe', '.dll', '.so')
        end
        additional_path = candidate_files.map do |file|
          File.dirname(file)
        end.sort.uniq.join(':')
        Xezat.logger.debug("    Additional PATH = #{additional_path.gsub(Regexp.new(variables[:D]), '')}")
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3({ 'PATH' => "#{additional_path}:#{ENV.fetch('PATH')}" }, command.join(' '))
        Xezat.logger.warn("    Stderr = #{error}") unless error.empty?
        raise CygportProcessError, error unless status.success?

        result
      end
    end
  end
end
