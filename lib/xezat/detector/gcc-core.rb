
require 'xezat/detectors'

module Xezat
  
  class GccCore < Detector
    
    Detectors.register('gcc-core', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.(c|h)$/ =~ File.basename(file)
          return ['gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
