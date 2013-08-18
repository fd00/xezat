
require 'xezat/detectors'

module Xezat
  
  class Binutils < Detector
    
    Detectors.register('binutils', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.[sS]$/ =~ File.basename(file)
          return ['binutils']
        end
      }
      []
    end

  end
  
end
