# frozen_string_literal: true

require 'xezat'
require 'xezat/ext/string'

module Xezat
  class DetectorManager
    def initialize(detector_dir = File.expand_path(File.join(File.dirname(__FILE__), 'detector')))
      Xezat.logger.debug('Load detectors')
      @detectors = {}
      Dir.glob(File.join(detector_dir, '*.rb')).sort.each do |rb|
        require rb
        @detectors[File.basename(rb, '.rb').intern] = Object.const_get("Xezat::Detector::#{File.basename(rb, '.rb').camelize}").new
      end
    end

    def detect(variables)
      Xezat.logger.debug('Detect tools')
      tools = []
      @detectors.each do |name, detector|
        if detector.detect(variables)
          tools << name
          Xezat.logger.debug("  #{name} ... yes")
        else
          Xezat.logger.debug("  #{name} ... no")
        end
      end
      tools
    end
  end
end
