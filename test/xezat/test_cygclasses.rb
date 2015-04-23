require 'xezat/cygclasses'

module Xezat::Test
  class CygclassesTest < Test::Unit::TestCase
    include Xezat

    def setup
      @cygclass_manager = CygclassManager.new(File.join(File.dirname(__FILE__), '..', 'cygport', 'cygclass'))
    end

    # 存在している cygclass
    def test_existent_cygclass
      assert_equal(true, @cygclass_manager.include?(:svn))
    end

    # 存在しない cygclass
    def test_nonexistent_cygclass
      assert_equal(false, @cygclass_manager.include?(:nonexistent))
    end

    # vcs である cygclass
    def test_vcs_cygclass
      assert_equal(true, @cygclass_manager.vcs?(:git))
    end

    # 存在しているが vcs ではない cygclass
    def test_novcs_cygclass
      assert_equal(false, @cygclass_manager.vcs?(:cmake))
    end

  end
end
