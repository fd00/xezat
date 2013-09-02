
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Cmake < Detector
    
    Detectors.register('cmake', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /^CMakeLists\.txt$/ =~ File.basename(file)
          return ['cmake', 'make']
        end
      }
      []
    end

  end
  
end