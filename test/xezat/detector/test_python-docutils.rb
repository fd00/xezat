require 'xezat/detectors'

module Xezat::Test::Detector
  class PythonDocutilsTest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:'python-docutils']
    end

    def test_yes
      assert_true(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'python-docutils', 'yes')}))
    end

    def test_no
      assert_false(@detector.detect({S: File::join(File::dirname(__FILE__), 'fixture', 'python-docutils', 'no')}))
    end
  end
end
