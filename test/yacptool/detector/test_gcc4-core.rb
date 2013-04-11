
require 'yacptool/detector/gcc4-core'

class Gcc4CoreTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Gcc4Core.new
    root_ok_c = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-core', 'ok_c'))
    assert_equal(['gcc4-core', 'binutils'], detector.get_components(root_ok_c))
    root_ok_h = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-core', 'ok_h'))
    assert_equal(['gcc4-core', 'binutils'], detector.get_components(root_ok_h))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-core', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
