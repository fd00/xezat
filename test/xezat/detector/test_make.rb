require 'xezat/detectors'

module Xezat::Test::Detector
  class MakeTest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:make]
    end

    def test_yes
      assert_true(@detector.detect({B: File::join(File::dirname(__FILE__), 'fixture', 'make', 'yes')}))
    end

    def test_yes_cygport
      assert_true(@detector.detect({B: File::join(File::dirname(__FILE__), 'fixture', 'make', 'no'),
                                    top: File::join(File::dirname(__FILE__), 'fixture', 'make', 'yes_cygport'),
                                    cygportfile: 'cygport_cygmake'}))
    end

    def test_no
      assert_false(@detector.detect({B: File::join(File::dirname(__FILE__), 'fixture', 'make', 'no'),
                                     top: File::join(File::dirname(__FILE__), 'fixture', 'make', 'yes_cygport'),
                                     cygportfile: 'cygport_empty'}))
    end
  end
end
