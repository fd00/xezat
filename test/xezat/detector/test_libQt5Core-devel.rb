require 'xezat/detectors'

module Xezat::Test::Detector
  class LibQt5CoreDevel < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:'libQt5Core-devel']
    end

    def test_yes_cygport
      top = File.join(File.dirname(__FILE__), 'fixture', 'libQt5Core-devel', 'yes_cygport')
      cygport = 'foo.cygport'
      assert_true(@detector.detect(top: top, cygportfile: cygport, S: top, PN: 'foo'))
    end

    def test_yes_dir
      top = File.join(File.dirname(__FILE__), 'fixture', 'libQt5Core-devel', 'yes_dir')
      cygport = 'foo.cygport'
      assert_true(@detector.detect(top: top, cygportfile: cygport, S: top, PN: 'foo'))
    end

    def test_no
      top = File.join(File.dirname(__FILE__), 'fixture', 'libQt5Core-devel', 'no')
      cygport = 'foo.cygport'
      assert_false(@detector.detect(top: top, cygportfile: cygport, S: top, PN: 'foo'))
    end
  end
end
