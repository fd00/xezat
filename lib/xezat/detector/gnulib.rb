require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Gnulib
      DetectorManager.register(:'gnulib', self)

      def detect(variables)
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('gnulib-tools')
        end
        false
      end
    end
  end
end
