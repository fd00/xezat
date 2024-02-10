# frozen_string_literal: true

module Xezat
  module Detector
    class AutoconfArchive
      def detect(variables)
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
