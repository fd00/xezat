
require 'xezat/detectors'

module Xezat
  
  class GccObjc < Detector
    
    Detectors.register('gcc-objc', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if /.+\.m$/ =~ File.basename(file)
          return ['gcc-objc', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
