
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Automake < Detector
    
    Detectors.register('automake', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^Makefile\.am$/ =~ File.basename(file)
            return ['automake']
          end
        end
      }
      []
    end

  end
  
end
