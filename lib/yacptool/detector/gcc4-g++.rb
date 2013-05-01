
require 'yacptool/detectors'

module Yacptool
  
  class Gcc4Gpp < Detector
    
    Detectors.register('gcc4-g++', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.(cc|C|cpp|cxx|hh|H|hpp|hxx)$/ =~ File.basename(file)
          return ['gcc4-g++', 'gcc4-core', 'binutils']
        end
      }
      []
    end

  end
  
end