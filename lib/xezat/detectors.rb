
require 'xezat/packages'

module Xezat
  
  # ソースツリーからビルドに必要なコンポーネントを検出する基底クラス
  class Detector

    # ソースツリーが条件を満たしているコンポーネント名の配列を返す
    def get_components(variables)
      []
    end

  end
  
  class DetectorManager
    
    def initialize
      @detectors = {}
    end

    def register(detector, klass)
      if @detectors.has_key?(detector)
        raise MultipleDetectorDefinitionException, "'#{detector}' already defined"
      end
      @detectors[detector] = klass.new
    end

    def get_components(root)
      components = []
      @detectors.select { |detector, instance|
        instance.get_components(root).each { |component|
          components << component
        }
      }
      components.uniq.sort
    end
    
    def load_detectors(path)
      Dir.glob(File.join(path, '*.rb')) { |rb|
        require rb
      }
    end
  
  end
  
  unless defined?(Detectors)
    Detectors = DetectorManager.new
    Detectors.load_detectors(File.join(File.dirname(__FILE__), 'detector'))
  end
  
end
