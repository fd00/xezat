
require 'xezat/detectors'

module Xezat
  
  class GccObjc < Detector
    
    Detectors.register('gcc-objc', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.m')
          return ['gcc-objc', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
