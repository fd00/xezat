
require 'xezat/detectors'

module Xezat
  
  class GccGpp < Detector
    
    Detectors.register('gcc-g++', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.(cc|C|cpp|cxx|hh|H|hpp|hxx)$/ =~ File.basename(file)
          return ['gcc-g++', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
