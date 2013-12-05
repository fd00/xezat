
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Libtool < Detector
    
    Detectors.register('libtool', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^ltmain\.sh$/ =~ File.basename(file)
            return ['libtool']
          end
        end
      }
      []
    end

  end
  
end
