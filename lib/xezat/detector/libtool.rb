require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Libtool
      DetectorManager::register(:libtool, self)

      def detect(variables)
        Find::find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'ltmain.sh')
        end
        false
      end
    end
  end
end
