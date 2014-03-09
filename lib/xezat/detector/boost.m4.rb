
require 'find'
require 'xezat/detectors'

module Xezat
  
  class BoostM4 < Detector
    
    Detectors.register('boost.m4', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')
          File.foreach(file) { |line|
            if line.lstrip.start_with?('BOOST_REQUIRE')
              return ['boost.m4']
            end
          }
        end
      }
      []
    end

  end
  
end
