
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Cmake < Detector
    
    Detectors.register('cmake', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^CMakeLists\.txt$/ =~ File.basename(file)
            return ['cmake']
          end
        end
      }
      []
    end

  end
  
end