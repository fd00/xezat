# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class XorgUtilMacros
      def detect?(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if line.start_with?('XORG_MACROS_VERSION')
          end
        end
        false
      end
    end
  end
end
