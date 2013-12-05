
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
  
  def test_get_files
    change = Change.new
    actual = change.get_files({
      :T => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'tmp')),
      :pkg_name => ['pkg', 'pkg-devel'],
      :PN => 'pkg',
    })
    expected = {
     'pkg'.intern => ['/usr/aaa/bbb', '/usr/share/doc/Cygwin/pkg.README'],
     'pkg-devel'.intern => ['/usr/ccc'], 
    }
    assert_equal(expected, actual)
  end
  
  # .lst が見つからない場合は例外が投げられる
  def test_get_files_lst_not_found
    change = Change.new
    assert_raise(IllegalStateException) {
      change.get_files({
        :T => '',
        :pkg_name => ['pkg', 'pkg-devel'],
        :PN => 'pkg',
      })
    }
  end
end
