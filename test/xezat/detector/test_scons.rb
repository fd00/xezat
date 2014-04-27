
require 'xezat/detector/scons'

class SconsTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Scons.new
    root_ok = {:top => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'scons', 'ok')),
               :cygportfile => 'xezat-0-0.cygport'}
    assert_equal(['scons'], detector.get_components(root_ok))
    root_ng = {:top => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'scons', 'ng')),
               :cygportfile => 'xezat-0-0.cygport'}
    assert_equal([], detector.get_components(root_ng))
  end

end
