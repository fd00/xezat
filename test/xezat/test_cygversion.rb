require 'xezat/cygversion'

module Xezat::Test
  class CygversionTest < Test::Unit::TestCase
    include Xezat
    def test_initialize
      cygversion = Cygversion.new('1.0.0-1bl1')
      assert_equal(['1.0.0', 19700101, '1bl1'] ,cygversion.to_a)
    end

    def test_initialize_hyphen
      cygversion = Cygversion.new('1.0.0-2-1bl1')
      assert_equal(['1.0.0-2', 19700101, '1bl1'] ,cygversion.to_a)
    end
    
    def test_initialize_vcs
      cygversion = Cygversion.new('1.0.0+git20150101-1bl1')
      assert_equal(['1.0.0', 20150101, '1bl1'] ,cygversion.to_a)
    end
    
    def test_compare
      cygversion_old = Cygversion.new('1.0.0-1bl1')
      cygversion_new = Cygversion.new('1.0.1-1bl1')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
    
    def test_compare_hyphen
      cygversion_old = Cygversion.new('1.0.0-1bl1')
      cygversion_new = Cygversion.new('1.0.0-1-1bl1')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
    
    def test_compare_git
      cygversion_old = Cygversion.new('1.0.0+git20140101-1bl1')
      cygversion_new = Cygversion.new('1.0.0+git20150101-1bl1')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
    
    def test_compare_svn
      cygversion_old = Cygversion.new('1.0.0+svn999-1bl1')
      cygversion_new = Cygversion.new('1.0.0+svn1000-1bl1')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
    
    def test_compare_novcs
      cygversion_old = Cygversion.new('1.0.0-1bl1')
      cygversion_new = Cygversion.new('1.0.0+git20150101-1bl1')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
    
    def test_compare_release
      cygversion_old = Cygversion.new('1.0.0+git20150101-1bl1')
      cygversion_new = Cygversion.new('1.0.0+git20150101-1bl2')
      assert_equal(-1, cygversion_old <=> cygversion_new)
    end
  end
end
