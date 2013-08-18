
require 'xezat/detector/cmake'

class CmakeTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Cmake.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'cmake', 'ok'))
    assert_equal(['cmake', 'make'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'cmake', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
