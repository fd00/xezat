require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Autoconf
      DetectorManager::register(:autoconf, self)
      def detect(variables)
        Find::find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
        end
        false
      end
    end
  end
end
