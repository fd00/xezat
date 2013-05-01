
require 'yacptool/detector/tcl'

class TclTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Tcl.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'tcl', 'ok'))
    assert_equal(['tcl'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'tcl', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
