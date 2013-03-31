
require 'yacptool/detectors'

module Yacptool
  
  class Cygport < Detector
    
    Detectors.register('cygport', self)
    
    def get_components(root)
      ['cygport']
    end

  end
  
end