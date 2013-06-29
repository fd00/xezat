
require 'find'
require 'yacptool/detectors'

module Yacptool
  
  class GobjectIntrospection < Detector
    
    Detectors.register('gobject-introspection', self)
    
    def get_components(root)
      Find.find(root) { |file|
        if /^configure\.(ac|in)$/ =~ File.basename(file)
          File.foreach(file) { |line|
            if /^GOBJECT_INTROSPECTION_CHECK/ =~ line
              return ['gobject-introspection', 'automake', 'autoconf', 'make']
            end
          }
        end
      }
      []
    end

  end
  
end