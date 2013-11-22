
require 'xezat/detectors'

module Xezat
  
  class GccFortran < Detector
    
    Detectors.register('gcc-fortran', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if /.+\.(f|F|f77|F77|f90|F90|f95|F95)$/ =~ File.basename(file)
          return ['gcc-fortran', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
