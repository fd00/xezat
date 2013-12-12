
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Flex < Detector
    
    Detectors.register('flex', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.l')
          return ['flex']
        end
      }
      []
    end

  end
  
end
