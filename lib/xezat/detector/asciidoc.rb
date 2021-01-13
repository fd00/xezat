# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Asciidoc
      def detect(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if line.lstrip.include?('asciidoc')
          end
        end
        false
      end
    end
  end
end
