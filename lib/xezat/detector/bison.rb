
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Bison < Detector
    
    Detectors.register('bison', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /.+\.(y|ypp)$/ =~ File.basename(file)
            return ['bison']
          end
        end
      }
      []
    end

  end
  
end
