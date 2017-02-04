require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Gengetopt
      DetectorManager.register(:gengetopt, self)

      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.ggo')
        end
        false
      end
    end
  end
end
