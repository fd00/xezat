
require 'tempfile'

require 'yacptool/command/patches'

class PatchesTest < Test::Unit::TestCase

  include Yacptool

  # 外部コマンドが正常終了する場合は正常終了する
  def test_get_raw_variables
    patches = Patches.new
    actual = patches.get_raw_variables('echo -n foo')
    assert_equal('foo', actual)
  end

  # 外部コマンドが異常終了する場合は例外が投げられる
  def test_get_raw_variables_with_error
    patches = Patches.new
    assert_raise(CygportProcessException) {
      patches.get_raw_variables('false')
    }
  end


  # 一行で書かれている場合
  def test_extract_hints_1line
    patches = Patches.new
    actual = patches.extract_hints("'foo1 foo2 foo3'")
    assert_equal(['foo1', 'foo2', 'foo3'], actual)
  end

  # さまざまな空白文字が入っている場合
  def test_extract_hints_1line_with_spaces
    patches = Patches.new
    actual = patches.extract_hints("'foo1 foo2     \\n    foo3'")
    assert_equal(['foo1', 'foo2', 'foo3'], actual)
  end

  # 制御文字が入っている場合
  def test_extract_hints_multilines
    patches = Patches.new
    actual = patches.extract_hints("$'\\nfoo1\\n\\tfoo2\\n\\tfoo3\\n'")
    assert_equal(['foo1', 'foo2', 'foo3'], actual)
  end


  # SRC_URI がある場合は正常終了する
  def test_get_src_uri
    patches = Patches.new
    actual = patches.get_src_uri({:SRC_URI => 'foo'})
    assert_equal('foo', actual)
  end

  # SRC_URI がない場合は例外が投げられる
  def test_get_src_uri_not_defined
    patches = Patches.new
    assert_raise(IllegalArgumentException) {
      patches.get_src_uri({})
    }
  end

  # 他の VCS が存在する場合はそちらを優先する
  def test_get_src_uri_overwrite
    patches = Patches.new
    actual = patches.get_src_uri({:SRC_URI => 'foo', :SVN_URI => 'bar', :DESCRIPTION => 'baz'})
    assert_equal('bar', actual)
  end

end