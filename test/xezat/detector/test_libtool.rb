
require 'xezat/detector/libtool'

class LibtoolTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Libtool.new
    root_ok = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'libtool', 'ok'))}
    assert_equal(['libtool'], detector.get_components(root_ok))
    root_ng = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'libtool', 'ng'))}
    assert_equal([], detector.get_components(root_ng))
  end

end
