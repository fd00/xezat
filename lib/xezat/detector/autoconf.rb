
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Autoconf < Detector
    
    Detectors.register('autoconf', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^configure\.(ac|in)$/ =~ File.basename(file)
            return ['autoconf']
          end
        end
      }
      []
    end

  end
  
end
