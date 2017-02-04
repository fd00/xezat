require 'xezat/detectors'

module Xezat::Test::Detector
  class CmakeTest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:cmake]
    end

    def test_yes_root
      assert_true(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'cmake', 'yes_root')))
    end

    def test_yes_subdir
      assert_true(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'cmake', 'yes_subdir')))
    end

    def test_no
      assert_false(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'cmake', 'no')))
    end
  end
end
