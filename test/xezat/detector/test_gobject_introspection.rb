
require 'xezat/detector/gobject-introspection'

class GobjectIntrospectionTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = GobjectIntrospection.new
    root_ok = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gobject-introspection', 'ok'))
    assert_equal(['gobject-introspection', 'automake', 'autoconf', 'make'], detector.get_components(root_ok))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gobject-introspection', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end