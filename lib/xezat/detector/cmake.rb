# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Cmake
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'CMakeLists.txt')
        end
        false
      end
    end
  end
end
