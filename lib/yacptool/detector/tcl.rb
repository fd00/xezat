
require 'yacptool/detectors'

module Yacptool
  
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