
require 'xezat/detector/autoconf'

class AutoconfTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Autoconf.new
    root_ok_ac = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'autoconf', 'ok_ac'))
    assert_equal(['autoconf', 'make'], detector.get_components(root_ok_ac))
    root_ok_in = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'autoconf', 'ok_in'))
    assert_equal(['autoconf', 'make'], detector.get_components(root_ok_in))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'autoconf', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
