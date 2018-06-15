require 'xezat'

module Xezat
  class DetectorManager
    def initialize(detector_dir = File.expand_path(File.join(File.dirname(__FILE__), 'detector')))
      LOG.debug('Load detectors')
      @detectors = {}
      Dir.glob(File.join(detector_dir, '*.rb')) do |rb|
        require rb
        @detectors[File.basename(rb, '.rb').intern] = Object.const_get("Xezat::Detector::#{Xezat::Detector.constants[-1]}").new
      end
    end

    def detect(variables)
      LOG.debug('Detect tools')
      tools = []
      @detectors.each do |name, detector|
        d = detector.class.name.split('::').last
        if detector.detect(variables)
          tools << name
          LOG.debug("  #{d} ... yes")
        else
          LOG.debug("  #{d} ... no")
        end
      end
      tools
    end
  end
end
