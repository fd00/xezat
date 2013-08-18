
require 'xezat/detector/gcc-objc'

class GccObjcTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = GccObjc.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-objc', 'ok'))
    assert_equal(['gcc-objc', 'gcc-core', 'binutils'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-objc', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
