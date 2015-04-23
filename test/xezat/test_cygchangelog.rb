require 'xezat/cygchangelog'

module Xezat::Test
  class CygchangelogTest < Test::Unit::TestCase
    include Xezat

    def test_initialize
      changelog = Cygchangelog.new(<<EOF
Port Notes:
      
----- version 2.0.0-1bl2 -----
Rebuild for xezat
next line

----- version 2.0.0-1bl1 -----
Version bump.

----- version 1.0.0-1bl1 -----
Initial release by fd0 <https://github.com/fd00/>

EOF
      )
      assert_equal(['Rebuild for xezat', 'next line'].join($/), changelog[:'2.0.0-1bl2'])
    end
  end
end
