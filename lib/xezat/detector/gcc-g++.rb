
require 'xezat/detectors'

module Xezat
  
  class GccGpp < Detector
    
    Detectors.register('gcc-g++', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.cc') || file.end_with?('.C') || file.end_with?('.cpp') || file.end_with?('.cxx') ||
           file.end_with?('.hh') || file.end_with?('.H') || file.end_with?('.hpp') || file.end_with?('.hxx')
          return ['gcc-g++', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
