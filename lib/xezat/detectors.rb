# frozen_string_literal: true

require 'xezat'
require 'xezat/ext/string'

module Xezat
  class DetectorManager
    def initialize(detector_dir = File.expand_path(File.join(File.dirname(__FILE__), 'detector')))
      LOG.debug('Load detectors')
      @detectors = {}
      Dir.glob(File.join(detector_dir, '*.rb')) do |rb|
        require rb
        @detectors[File.basename(rb, '.rb').intern] = Object.const_get("Xezat::Detector::#{File.basename(rb, '.rb').camelize}").new
      end
    end

    def detect(variables)
      LOG.debug('Detect tools')
      tools = []
      @detectors.each do |name, detector|
        if detector.detect(variables)
          tools << name
          LOG.debug("  #{name} ... yes")
        else
          LOG.debug("  #{name} ... no")
        end
      end
      tools
    end
  end
end
