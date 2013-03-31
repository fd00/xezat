
require 'find'
require 'yacptool/detectors'

module Yacptool
  
  class Cmake < Detector
    
    Detectors.register('cmake', self)
    
    def get_components(root)
      Find.find(root) { |file|
        return ['cmake', 'make'] if /^CMakeLists\.txt$/ =~ File.basename(file)
      }
      []
    end

  end
  
end