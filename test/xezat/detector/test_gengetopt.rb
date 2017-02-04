require 'xezat/detectors'

module Xezat::Test::Detector
  class GengetoptTest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:gengetopt]
    end

    def test_yes_root
      assert_true(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'gengetopt', 'yes_root')))
    end

    def test_yes_subdir
      assert_true(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'gengetopt', 'yes_subdir')))
    end

    def test_no
      assert_false(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'gengetopt', 'no')))
    end
  end
end
