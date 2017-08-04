require 'find'

module Xezat
  module Detector
    class Autoconf
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
        end
        false
      end
    end
  end
end
