require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Automake
      DetectorManager::register(:automake, self)
      def detect(variables)
        Find::find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'Makefile.am')
        end
        false
      end
    end
  end
end
