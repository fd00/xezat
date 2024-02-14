# frozen_string_literal: true

module Xezat
  module Detector
    class AutoconfArchive
      def detect(variables)
        return false unless variables.keys.index do |key|
          %i[_cmake_CYGCLASS_ _meson_CYGCLASS_ _ninja_CYGCLASS_].include?(key)
        end.nil?

        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if line.strip.start_with?('AX_')
          end
        end
        false
      end
    end
  end
end
