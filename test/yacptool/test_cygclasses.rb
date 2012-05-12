
require 'yacptool/cygclasses'

class CygclassesTest < Test::Unit::TestCase
  
  include Yacptool
  
  def setup
    here = File.dirname(__FILE__)
    @cygclasses = CygclassManager.new(File.join(here, '/fixture/cygclass'))
  end

  def test_existent_cygclass
    assert_equal(true, @cygclasses.exists?(:svn))
  end

  def test_nonexistent_cygclass
    assert_equal(false, @cygclasses.exists?(:nonexistent))
  end

end