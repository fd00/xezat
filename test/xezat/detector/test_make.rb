
require 'xezat/detector/make'

class MakeTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Make.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'make', 'ok'))
    assert_equal(['make'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'make', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
