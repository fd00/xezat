
require 'yacptool/detectors'

module Yacptool
  
  class Binutils < Detector
    
    Detectors.register('binutils', self)
    
    def get_components(root)
      Find.find(root) { |file|
        return ['binutils'] if /.+\.[sS]$/ =~ File.basename(file)
      }
      []
    end

  end
  
end