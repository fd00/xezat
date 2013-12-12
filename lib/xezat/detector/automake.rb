
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Automake < Detector
    
    Detectors.register('automake', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?(File::SEPARATOR + 'Makefile.am')
          return ['automake']
        end
      }
      []
    end

  end
  
end
