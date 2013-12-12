
require 'xezat/detectors'

module Xezat
  
  class GccCore < Detector
    
    Detectors.register('gcc-core', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.c') || file.end_with?('.h')            
          return ['gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
