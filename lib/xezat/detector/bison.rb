
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Bison < Detector
    
    Detectors.register('bison', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.y') || file.end_with?('.ypp')
          return ['bison']
        end
      }
      []
    end

  end
  
end
