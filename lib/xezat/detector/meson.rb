require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Meson
      DetectorManager.register(:'meson', self)

      def detect(variables)
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('meson')
        end
        false
      end
    end
  end
end
