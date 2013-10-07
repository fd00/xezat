
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Bison < Detector
    
    Detectors.register('bison', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.(y|ypp)$/ =~ File.basename(file)
          return ['bison']
        end
      }
      []
    end

  end
  
end
