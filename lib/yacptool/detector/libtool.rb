
require 'find'
require 'yacptool/detectors'

module Yacptool
  
  class Libtool < Detector
    
    Detectors.register('libtool', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /^ltmain\.sh$/ =~ File.basename(file)
          return ['libtool']
        end
      }
      []
    end

  end
  
end