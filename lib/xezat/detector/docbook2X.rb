# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Docbook2x
      def detect?(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if line.include?('docbook2x-man')
          end
        end
        false
      end
    end
  end
end
