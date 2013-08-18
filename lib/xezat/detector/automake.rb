
require 'find'
require 'xezat/detectors'

module Xezat
  
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
