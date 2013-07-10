
require 'yacptool/detector/gcc-core'

class GccCoreTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = GccCore.new
    root_ok_c = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-core', 'ok_c'))
    assert_equal(['gcc-core', 'binutils'], detector.get_components(root_ok_c))
    root_ok_h = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-core', 'ok_h'))
    assert_equal(['gcc-core', 'binutils'], detector.get_components(root_ok_h))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-core', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
