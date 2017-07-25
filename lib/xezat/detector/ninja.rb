require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Ninja
      DetectorManager.register(:'ninja', self)

      def detect(variables)
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('ninja')
        end
        false
      end
    end
  end
end
