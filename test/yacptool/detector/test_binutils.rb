
require 'yacptool/detector/binutils'

class BinutilsTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Binutils.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'binutils', 'ok'))
    assert_equal(['binutils'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'binutils', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
