
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Gengetopt < Detector
    
    Detectors.register('gengetopt', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if /.+\.ggo$/ =~ File.basename(file)
          return ['gengetopt']
        end
      }
      []
    end

  end
  
end
