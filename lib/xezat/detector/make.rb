require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class Make
      DetectorManager::register(:make, self)

      def detect(variables)
        Find::find(variables[:B]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'Makefile')
        end
        File::foreach(File::join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('cygmake')
        end
        false
      end
    end
  end
end
