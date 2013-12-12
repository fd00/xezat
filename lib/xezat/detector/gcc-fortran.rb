
require 'xezat/detectors'

module Xezat
  
  class GccFortran < Detector
    
    Detectors.register('gcc-fortran', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?('.f') || file.end_with?('.F') || file.end_with?('.f77') || file.end_with?('.F77') ||
           file.end_with?('.f90') || file.end_with?('.F90') || file.end_with?('.f95') || file.end_with?('.F95')
          return ['gcc-fortran', 'gcc-core', 'binutils']
        end
      }
      []
    end

  end
  
end
