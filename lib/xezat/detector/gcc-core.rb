
require 'xezat/detectors'

module Xezat
  
  class GccCore < Detector
    
    Detectors.register('gcc-core', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /.+\.(c|h)$/ =~ File.basename(file)
            return ['gcc-core', 'binutils']
          end
        end
      }
      []
    end

  end
  
end
