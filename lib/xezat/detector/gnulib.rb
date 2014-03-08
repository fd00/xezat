
require 'xezat/detectors'

module Xezat
  
  class Gnulib < Detector
    
    Detectors.register('gnulib', self)
    
    def get_components(variables)
      cygport = File.join(variables[:top], variables[:cygportfile])
      File.foreach(cygport) { |line|
        if line.index('gnulib-tool')
          return ['gnulib']
        end
      }
      []
    end

  end
  
end
