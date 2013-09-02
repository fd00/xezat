
require 'xezat/variables'

class VariableManagerTest < Test::Unit::TestCase

  include Xezat

  def test_parsing
    variables = VariableManager.new(<<EOL)
DESCRIPTION=$'\\nThat\\'s good\\n\\nxxx\\tyyy\\tzzz'
E=F
G='Single Quoted'
H=([0]="aaa" [1]="bbb")
mirror_gnu=$'\\n\\thttp://ftpmirror.gnu.org\\n\\tftp://ftp.gnu.org/gnu\\n'
myfunc() 
{
  :
}
A=B
EOL
    assert_equal(['', "That's good", '', 'xxxyyyzzz'], variables[:DESCRIPTION])
    assert_equal('F', variables[:E])
    assert_equal('Single Quoted', variables[:G])
    assert_equal(['aaa', 'bbb'], variables[:H])
    assert_equal(['http://ftpmirror.gnu.org', 'ftp://ftp.gnu.org/gnu'], variables[:mirror_gnu])
    assert_nil(variables[:A])
  end

end
