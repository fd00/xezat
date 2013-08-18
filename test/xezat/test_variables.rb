
require 'xezat/variables'

class VariableManagerTest < Test::Unit::TestCase

  include Xezat

  def test_parsing
    variables = VariableManager.new(<<EOL)
E=F
G='Single Quoted'
H=([0]="0" [1]="1")
myfunc() 
{
  :
}
A=B
EOL
    assert_equal('F', variables[:E])
    assert_equal('Single Quoted', variables[:G])
    assert_equal('([0]="0" [1]="1")', variables[:H])
    assert_nil(variables[:A])
  end

end
