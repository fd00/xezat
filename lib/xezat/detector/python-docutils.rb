require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class PythonDocutils
      DetectorManager::register(:'python-docutils', self)

      def detect(variables)
        Find::find(variables[:S]) do |file|
          if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
            File::foreach(file) do |line|
              return true if line.lstrip.start_with?('AC_CHECK_PROGS') && line.index('rst2man').is_a?(Integer)
            end
          end
        end
        false
      end
    end
  end
end
