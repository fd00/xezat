
require 'find'
require 'xezat/detectors'

module Xezat
  
  class PythonGyp < Detector
    
    Detectors.register('gyp', self)
    
    def get_components(variables)
      cygport = File.join(variables[:top], variables[:cygportfile])
      File.foreach(cygport) { |line|
        if /gyp/ =~ line
          return ['python-gyp']
        end
      }
      []
    end

  end
  
end
