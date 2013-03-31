
require 'yacptool/detectors'

module Yacptool
  
  class Make < Detector
    
    Detectors.register('make', self)
    
    def get_components(root)
      Find.find(root) { |file|
        return ['make'] if /^[Mm]akefile/ =~ File.basename(file)
      }
      []
    end

  end
  
end