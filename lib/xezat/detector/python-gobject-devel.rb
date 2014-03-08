
require 'find'
require 'xezat/detectors'

module Xezat
  
  class PythonGobjectDevel < Detector
    
    Detectors.register('python-gobject-devel', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
          File.foreach(file) { |line|
            if /pygobject-codegen-2.0/ =~ line
              return ['python-gobject-devel']
            end
          }
        end
      }
      []
    end

  end
  
end
