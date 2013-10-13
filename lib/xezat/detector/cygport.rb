
require 'xezat/detectors'

module Xezat
  
  class Cygport < Detector
    
    Detectors.register('cygport', self)
    
    def get_components(variables)
      ['cygport']
    end

  end
  
end
