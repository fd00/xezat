
require 'tempfile'

require 'xezat/command/create'

class CreateTest < Test::Unit::TestCase

  include Xezat
  
  def setup
    @cygclass_manager =
      CygclassManager.new(File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixture', 'cygclasses')))
    @template_variables = {
      :HOMEPAGE => 'homepage',
      :SRC_URI => 'srcuri',
      :GIT_URI => 'gituri',
    }
  end
  
  def test_get_template_variables()
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    create.template_variables = @template_variables
    actual = create.get_template_variables([])
    assert_equal({
      :HOMEPAGE => 'homepage',
      :SRC_URI => 'srcuri',
    }, actual)
  end
  
  def test_get_template_variables_with_cygclass()
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    create.template_variables = @template_variables
    actual = create.get_template_variables([:git])
    assert_equal({
      :HOMEPAGE => 'homepage',
      :GIT_URI => 'gituri',
    }, actual)
  end
  
  def test_get_template_variables_with_invalid_cygclass()
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    create.template_variables = @template_variables
    assert_raise(NoSuchCygclassException) {
      create.get_template_variables([:notcygclass])
    }
  end
  
  def test_get_template_variables_with_cygclasses_conflict()
    create = Create.new
    create.cygclass_manager = @cygclass_manager
    create.template_variables = @template_variables
    assert_raise(CygclassConflictException) {
      create.get_template_variables([:git, :hg])
    }
  end
  
  def test_get_cygport()
    create = Create.new
    template_variables = {
      :HOMEPAGE => 'homepage',
      :GIT_URI => 'gituri',
    }
    category = 'Utils'
    cygclasses = [:git, :cmake]
    actual = create.get_cygport(template_variables, category, cygclasses)
    expected = <<"EOS"
HOMEPAGE="homepage"
GIT_URI="gituri"

CATEGORY="Utils"
SUMMARY=""
DESCRIPTION=""

inherit git
inherit cmake
EOS
    assert_equal(expected, actual)
  end
  
  def test_get_cygport_no_category_and_inheritance()
    create = Create.new
    template_variables = {
      :HOMEPAGE => 'homepage',
      :SRC_URI => 'srcuri',
      :GIT_URI => 'gituri',
    }
    category = ''
    cygclasses = []
    actual = create.get_cygport(template_variables, category, cygclasses)
    expected = <<"EOS"
HOMEPAGE="homepage"
SRC_URI="srcuri"

CATEGORY=""
SUMMARY=""
DESCRIPTION=""

EOS
  end
end
