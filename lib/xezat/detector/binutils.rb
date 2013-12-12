
require 'xezat/detectors'

module Xezat
  
  class Binutils < Detector
    
    Detectors.register('binutils', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.s') || file.end_with?('.S')
          return ['binutils']
        end
      }
      []
    end

  end
  
end
