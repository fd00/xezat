# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python39Docutils
      def detect?(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if line.scrub.strip.start_with?('AC_CHECK_PROG') && line.index('rst2man').is_a?(Integer)
          end
        end
        if variables.key?(:_meson_CYGCLASS_)
          File.foreach(File.join(variables[:S], 'meson.build')) do |line|
            return true if line.strip.index('rst2man').is_a?(Integer)
          end
        end
        false
      end
    end
  end
end
