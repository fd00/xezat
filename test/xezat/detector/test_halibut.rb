require 'xezat/detectors'

module Xezat::Test::Detector
  class HalibutTest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:halibut]
    end

    def test_yes_root
      assert_true(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'halibut', 'yes_root')}))
    end

    def test_yes_subdir
      assert_true(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'halibut', 'yes_subdir')}))
    end

    def test_no
      assert_false(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'halibut', 'no')}))
    end
  end
end
