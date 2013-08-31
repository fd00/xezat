
require 'xezat/hint'

class HintTest < Test::Unit::TestCase
  
  include Xezat
  
  def test_initialize
    hint = Hint.new(<<EOL)
sdesc: "sdesc contents"
ldesc: "ldesc contents"
category: Admin X11
requires: cygwin libabcdefghij1.0_0 libabcdefghij1.0-devel
EOL
    assert_equal('sdesc contents', hint.sdesc)
    assert_equal('ldesc contents', hint.ldesc)
    assert_equal(['Admin', 'X11'], hint.category)
    assert_equal(['cygwin', 'libabcdefghij1.0_0', 'libabcdefghij1.0-devel'], hint.requires)
  end
  
  def test_initialize_ldesc
    hint = Hint.new(<<EOL)
sdesc: "sdesc contents"
ldesc: "ldesc contents
is long
is long"
category: Admin X11
requires: cygwin libabcdefghij1.0_0 libabcdefghij1.0-devel
EOL
    assert_equal('sdesc contents', hint.sdesc)
    assert_equal(<<EOL.strip, hint.ldesc)
ldesc contents
is long
is long
EOL
    assert_equal(['Admin', 'X11'], hint.category)
    assert_equal(['cygwin', 'libabcdefghij1.0_0', 'libabcdefghij1.0-devel'], hint.requires)
  end
  
  def test_manager
    here = File.dirname(__FILE__)
    hints = HintManager.new(File.join(here, 'fixture', 'hint'))
    
    assert_equal(hints[:aaa].version ,'0.0.0-1')
    assert_equal(hints[:aaa].install.checksum ,'c71705507ce8d961595bcd128185c61b')
    assert_equal(hints[:aaa].install.path ,'x86/release/aaa/aaa-0.0.0-1.tar.bz2')
    assert_equal(hints[:aaa].install.size ,198)
    assert_equal(hints[:aaa].source.checksum ,'b9cf561f835f6a4d21fa46bcb40bd35a')
    assert_equal(hints[:aaa].source.path ,'x86/release/aaa/aaa-0.0.0-1-src.tar.bz2')
    assert_equal(hints[:aaa].source.size ,209)
    
    assert_equal(hints[:libaaa0].version ,'0.0.0-1')
    assert_equal(hints[:libaaa0].install.checksum ,'f8f035e2da5743ce03dbbb334ccd8fe4')
    assert_equal(hints[:libaaa0].install.path ,'x86/release/aaa/libaaa0/libaaa0-0.0.0-1.tar.bz2')
    assert_equal(hints[:libaaa0].install.size ,205)
    assert_equal(hints[:libaaa0].source.checksum ,'b9cf561f835f6a4d21fa46bcb40bd35a')
    assert_equal(hints[:libaaa0].source.path ,'x86/release/aaa/aaa-0.0.0-1-src.tar.bz2')
    assert_equal(hints[:libaaa0].source.size ,209)
  end
end
