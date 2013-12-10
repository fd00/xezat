
require 'find'
require 'xezat/detectors'

module Xezat
  
  class GobjectIntrospection < Detector
    
    Detectors.register('gobject-introspection', self)
    
    def get_components(variables)
      Find.find(variables[:S]) { |file|
        if file.encoding == Encoding:: UTF_8 or file.encoding == Encoding::US_ASCII
          if /^configure\.(ac|in)$/ =~ File.basename(file)
            File.foreach(file) { |line|
              if line.start_with?('GOBJECT_INTROSPECTION_CHECK')
                return ['gobject-introspection']
              end
            }
          end
        end
      }
      []
    end

  end
  
end
