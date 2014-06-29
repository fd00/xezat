
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Cmake < Detector
    
    Detectors.register('cmake', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?(File::SEPARATOR + 'CMakeLists.txt')
          return ['cmake', 'make']
        end
      }
      []
    end

  end
  
end