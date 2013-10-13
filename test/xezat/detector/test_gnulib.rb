
require 'xezat/detector/gnulib'

class GnulibTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Gnulib.new
    root_ok = {:top => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gnulib', 'ok')),
               :cygportfile => 'xezat-0-0.cygport'}
    assert_equal(['gnulib'], detector.get_components(root_ok))
    root_ng = {:top => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gnulib', 'ng')),
               :cygportfile => 'xezat-0-0.cygport'}
    assert_equal([], detector.get_components(root_ng))
  end

end
