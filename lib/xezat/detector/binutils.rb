
require 'xezat/detectors'

module Xezat
  
  class Binutils < Detector
    
    Detectors.register('binutils', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /.+\.[sS]$/ =~ File.basename(file)
            return ['binutils']
          end
        end
      }
      []
    end

  end
  
end
