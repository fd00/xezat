
require 'xezat/detectors'

module Xezat
  
  class Qt5QmakeCore < Detector
    
    Detectors.register('qt5-qmake', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.pro')
          return ['libQt5Core-devel']
        end
      }
      []
    end

  end
  
end
