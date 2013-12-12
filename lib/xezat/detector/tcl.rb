
require 'xezat/detectors'

module Xezat
  
  class Tcl < Detector
    
    Detectors.register('tcl', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.tcl')
          return ['tcl']
        end
      }
      []
    end

  end
  
end
