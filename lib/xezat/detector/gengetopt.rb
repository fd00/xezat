require 'find'

module Xezat
  module Detector
    class Gengetopt
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.ggo')
        end
        false
      end
    end
  end
end
