
require 'xezat/detectors'

module Xezat
  
  class Ruby < Detector
    
    Detectors.register('ruby', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.rb')
          return ['ruby']
        end
      }
      []
    end

  end
  
end
