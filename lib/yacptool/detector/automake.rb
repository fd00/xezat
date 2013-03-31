
require 'find'
require 'yacptool/detectors'

module Yacptool
  
  class Automake < Detector
    
    Detectors.register('automake', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /^Makefile\.am$/ =~ File.basename(file)
          return ['automake', 'autoconf', 'make']
        end
      }
      []
    end

  end
  
end