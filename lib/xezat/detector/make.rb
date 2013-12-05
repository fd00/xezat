
require 'xezat/detectors'

module Xezat
  
  class Make < Detector
    
    Detectors.register('make', self)
    
    def get_components(variables)
      Find.find(variables[:B]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^[Mm]akefile/ =~ File.basename(file).encode('ASCII')
            return ['make']
          end
        end
      }
      []
    end

  end
  
end
