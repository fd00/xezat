
require 'yacptool/detectors'

module Yacptool
  
  class Gcc4Core < Detector
    
    Detectors.register('gcc4-core', self)
    
    def get_components(root)
      Find.find(root) { |file|
        return ['gcc4-core', 'binutils'] if /.+\.c$/ =~ File.basename(file)
      }
      []
    end

  end
  
end