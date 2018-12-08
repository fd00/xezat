# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Libtool
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'ltmain.sh')
        end
        Find.find(variables[:S]) do |file|
          next unless file.end_with?(File::SEPARATOR + 'Makefile') || file.end_with?(File::SEPARATOR + 'makefile')

          File.foreach(file) do |line|
            return true if line.lstrip.include?('libtool')
          end
        end
        false
      end
    end
  end
end
