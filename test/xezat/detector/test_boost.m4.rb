require 'xezat/detectors'

module Xezat::Test::Detector
  class BoostM4Test < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:'boost.m4']
    end

    def test_yes
      assert_true(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'boost.m4', 'yes')}))
    end

    def test_no
      assert_false(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'boost.m4', 'no')}))
    end
  end
end
