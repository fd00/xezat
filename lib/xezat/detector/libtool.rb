
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Libtool < Detector
    
    Detectors.register('libtool', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?(File::SEPARATOR + 'ltmain.sh')
          return ['libtool']
        end
      }
      []
    end

  end
  
end
