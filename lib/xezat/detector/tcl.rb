
require 'xezat/detectors'

module Xezat
  
  class Tcl < Detector
    
    Detectors.register('tcl', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /.+\.tcl$/ =~ File.basename(file)
            return ['tcl']
          end
        end
      }
      []
    end

  end
  
end
