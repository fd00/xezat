require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class LibQt5CoreDevel
      DetectorManager::register(:'libQt5Core-devel', self)

      def detect(variables)
        File::foreach(File::join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('qt5-qmake')
        end
        Find::find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + variables[:PN] + '.pro')
        end
        false
      end
    end
  end
end
