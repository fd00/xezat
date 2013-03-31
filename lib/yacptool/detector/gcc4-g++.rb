
require 'yacptool/detectors'

module Yacptool
  
  class Gcc4Gpp < Detector
    
    Detectors.register('gcc4-g++', self)
    
    def get_components(root)
      Find.find(root) { |file|
        return ['gcc4-g++', 'gcc4-core', 'binutils'] if /.+\.(cc|C|cpp|hh|H|hpp)$/ =~ File.basename(file)
      }
      []
    end

  end
  
end