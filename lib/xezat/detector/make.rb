
require 'xezat/detectors'

module Xezat
  
  class Make < Detector
    
    Detectors.register('make', self)
    
    def get_components(variables)
      Find.find(variables[:B]) { |file|
        if /^[Mm]akefile/ =~ File.basename(file)
          return ['make']
        end
      }
      []
    end

  end
  
end
