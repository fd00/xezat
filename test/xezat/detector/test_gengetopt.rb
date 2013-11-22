
require 'xezat/detector/gengetopt'

class GengetoptTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Gengetopt.new
    root_ok = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gengetopt', 'ok'))}
    assert_equal(['gengetopt'], detector.get_components(root_ok))
    root_ng = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gengetopt', 'ng'))}
    assert_equal([], detector.get_components(root_ng))
  end

end
