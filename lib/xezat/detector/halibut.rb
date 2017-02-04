require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Halibut
      DetectorManager.register(:halibut, self)

      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.but')
        end
        false
      end
    end
  end
end
