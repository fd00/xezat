
require 'yacptool/detectors'

module Yacptool
  
  class GccObjc < Detector
    
    Detectors.register('gcc-objc', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.m$/ =~ File.basename(file)
          return ['gcc-objc', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end