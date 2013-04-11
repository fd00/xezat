
require 'yacptool/detector/libtool'

class LibtoolTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Libtool.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'libtool', 'ok'))
    assert_equal(['libtool'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'libtool', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
