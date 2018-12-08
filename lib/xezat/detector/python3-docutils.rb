# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python3Docutils
      def detect(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')

          File.foreach(file) do |line|
            return true if line.strip.start_with?('AC_CHECK_PROG') && line.index('rst2man').is_a?(Integer)
          end
        end
        false
      end
    end
  end
end
