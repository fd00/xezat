
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Autoconf < Detector
    
    Detectors.register('autoconf', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|        
        if file.end_with?(File::SEPARATOR + 'configure.ac') ||
          file.end_with?(File::SEPARATOR + 'configure.in')
          return ['autoconf']
        end
      }
      []
    end

  end
  
end
