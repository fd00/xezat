
require 'tempfile'

require 'yacptool/command/create'

class CreateTest < Test::Unit::TestCase

  include Yacptool
  
  def setup
    @cygclass_manager =
      CygclassManager.new(File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixture', 'cygclass')))
  end

  # 引数がない場合は生成する cygport のファイルパスが不明なため例外が投げられる
  def test_no_argv
    create = Create.new
    assert_raise(IllegalArgumentOfCommandException) {
      create.run([])
    }
  end

  # cygport のファイルパスが指定されている場合はファイルが生成される
  def test_cygport
    create = Create.new
    cygport = Tempfile.new(['yacptool', '.cygport'])
    create.run(['-o', cygport.path])
    cygport.close(false)
    cygport.open
    lines = cygport.readlines
    assert_equal(4, lines.length)
    assert_equal('DESCRIPTION=""', lines[0].strip)
    assert_equal('HOMEPAGE=""', lines[1].strip)
    assert_equal('SRC_URI=""', lines[2].strip)
    cygport.close(true)
  end


  # 正常な cygclass が指定されている場合は SRC_URI が上書きされる
  def test_resolving_valid_cygclass
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    variables = {:SRC_URI => ''}
    create.resolve([:svn], variables)
    assert_equal({:SVN_URI => ''} , variables)
  end

  # 不正な cygclass が指定されている場合は例外が投げられる
  def test_resolving_invalid_cygclass
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    assert_raise(NoSuchCygclassException) {
      create.resolve([:invalid], {})
    }
  end

  # 複数の vcs cygclass が指定されている場合は衝突している旨の例外が投げられる
  def test_resolving_cygclass_conflict
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    assert_raise(CygclassConflictException) {
      create.resolve([:svn, :git], {})
    }
  end

  # 正常なテンプレートが指定されている場合は適切な初期値がセットされる
  def test_valid_template
    create = Create.new
    cygport = Tempfile.new(['yacptool', '.cygport'])
    create.run(['-t', 'sourceforge', '-o', cygport.path])
    cygport.close(false)
    cygport.open
    lines = cygport.readlines
    assert_equal(4, lines.length)
    assert_equal('DESCRIPTION=""', lines[0].strip)
    assert_equal('HOMEPAGE="http://${PN}.sf.net/"', lines[1].strip)
    assert_equal('SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"', lines[2].strip)
    cygport.close(true)
  end

  # 不正なテンプレートが指定されている場合は例外が投げられる
  def test_invalid_template
    create = Create.new
    cygport = Tempfile.new(['yacptool', '.cygport'])
    assert_raise(NoSuchTemplateException) {
      create.parse(['-t', 'invalid', '-o', cygport.path])
    }
    cygport.close(true)
  end

  # cygport をオプション無しで上書きしようとする場合は例外が投げられる
  def test_generating_existing_cygport
    create = Create.new
    cygport = Tempfile.new(['yacptool', '.cygport'])
    assert_raise(UnoverwritableConfigurationException) {
      create.generate(cygport, false, {}, [])
    }
    cygport.close(true)
  end

end
