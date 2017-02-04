require 'xezat/detectors'

module Xezat::Test::Detector
  class GObjectIntrospectiontest < Test::Unit::TestCase
    include Xezat::Detector
    include Xezat

    def setup
      @detector = DetectorManager[:'gobject-introspection']
    end

    def test_yes
      assert_true(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'gobject-introspection', 'yes')))
    end

    def test_no
      assert_false(@detector.detect(S: File.join(File.dirname(__FILE__), 'fixture', 'gobject-introspection', 'no')))
    end
  end
end
