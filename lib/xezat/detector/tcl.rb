
require 'xezat/detectors'

module Xezat
  
  class Tcl < Detector
    
    Detectors.register('tcl', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.tcl$/ =~ File.basename(file)
          return ['tcl']
        end
      }
      []
    end

  end
  
end
