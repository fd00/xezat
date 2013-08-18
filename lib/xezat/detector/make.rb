
require 'xezat/detectors'

module Xezat
  
  class Make < Detector
    
    Detectors.register('make', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /^[Mm]akefile/ =~ File.basename(file)
          return ['make']
        end
      }
      []
    end

  end
  
end
