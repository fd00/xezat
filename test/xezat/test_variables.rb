require 'xezat/variables'

module Xezat::Test
  class VariableManagerTest < Test::Unit::TestCase
    include Xezat

    def test_variable
      variables = VariableManager.new(<<EOF
!ruby/sym HOMEPAGE: "https://github.com/fd00/xezat"
!ruby/sym GIT_URI: "https://github.com/fd00/xezat.git"
EOF
                                     )
      assert_equal('https://github.com/fd00/xezat', variables[:HOMEPAGE])
    end
  end
end
