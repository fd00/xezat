
require 'yacptool/detectors'

module Yacptool
  
  class GccFortran < Detector
    
    Detectors.register('gcc-fortran', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /.+\.(f|F|f77|F77|f90|F90)$/ =~ File.basename(file)
          return ['gcc-fortran', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end