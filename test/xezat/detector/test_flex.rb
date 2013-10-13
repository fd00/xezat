
require 'xezat/detector/flex'

class FlexTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Flex.new
    root_ok = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'flex', 'ok'))}
    assert_equal(['flex'], detector.get_components(root_ok))
    root_ng = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'flex', 'ng'))}
    assert_equal([], detector.get_components(root_ng))
  end

end
