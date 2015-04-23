require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class GobjectIntrospection
      DetectorManager::register(:'gobject-introspection', self)

      def detect(variables)
        Find::find(variables[:S]) do |file|
          if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
            File::foreach(file) do |line|
              return true if line.lstrip.start_with?('GOBJECT_INTROSPECTION_CHECK')
            end
          end
        end
        false
      end
    end
  end
end
