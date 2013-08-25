
require 'xezat/command/change'

class ChangeTest < Test::Unit::TestCase

  include Xezat
  
  # SRC_URI がある場合は正常終了する
  def test_get_src_uri
    change = Change.new
    actual = change.get_src_uri({:SRC_URI => 'foo'})
    assert_equal('foo', actual)
  end

  # SRC_URI がない場合は例外が投げられる
  def test_get_src_uri_not_defined
    change = Change.new
    assert_raise(IllegalArgumentException) {
      change.get_src_uri({})
    }
  end
  
  # 他の VCS が存在する場合はそちらを優先する
  def test_get_src_uri_overwrite
    change = Change.new
    actual = change.get_src_uri({:SRC_URI => 'foo', :SVN_URI => 'bar', :DESCRIPTION => 'baz'})
    assert_equal('bar', actual)
  end

  # PATCH_URI が存在する場合は無視する
  def test_get_src_uri_not_overwrite
    change = Change.new
    actual = change.get_src_uri({:SRC_URI => 'foo', :PATCH_URI => 'bar', :DESCRIPTION => 'baz'})
    assert_equal('foo', actual)
  end
end
