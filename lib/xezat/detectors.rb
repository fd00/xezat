module Xezat
  class DetectorManager
    def initialize(detector_dir = File.expand_path(File.join(File.dirname(__FILE__), 'detector')))
      @detectors = {}
      Dir.glob(File.join(detector_dir, '*.rb')) do |rb|
        require rb
        @detectors[File.basename(rb, '.rb').intern] = Object.const_get("Xezat::Detector::#{Xezat::Detector.constants[-1]}").new
      end
    end

    def detect(variables)
      tools = []
      @detectors.each do |name, detector|
        tools << name if detector.detect(variables)
      end
      tools
    end
  end
end
