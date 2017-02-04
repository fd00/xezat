require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Cmake
      DetectorManager.register(:cmake, self)

      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'CMakeLists.txt')
        end
        false
      end
    end
  end
end
