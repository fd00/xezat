
require 'find'
require 'xezat/detectors'

module Xezat
  
  class Scons < Detector
    
    Detectors.register('scons', self)
    
    def get_components(variables)
      cygport = File.join(variables[:top], variables[:cygportfile])
      File.foreach(cygport) { |line|
        if /scons/ =~ line
          return ['scons']
        end
      }
      []
    end

  end
  
end
