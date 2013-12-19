
require 'xezat/command/change'

class ChangeTest < Test::Unit::TestCase

  include Xezat
  
  def setup
    @cygclass_manager =
      CygclassManager.new(File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixture', 'cygclasses')))
  end
  
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
  
  # 他の VCS が存在しても fetch がなければ SRC_URI を使用する
  def test_get_src_uri_defined_only
    change = Change.new
    actual = change.get_src_uri({:SRC_URI => 'srcuri', :SVN_URI => 'svnuri'}, @cygclass_manager)
    assert_equal('srcuri', actual)
  end

  # fetch が存在する場合は XXX_URI を使用する
  def test_get_src_uri_with_definition
    change = Change.new
    actual = change.get_src_uri({:_svn_CYGCLASS_ => '1', :SRC_URI => 'srcuri', :SVN_URI => 'svnuri'}, @cygclass_manager)
    assert_equal('svnuri', actual)
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
