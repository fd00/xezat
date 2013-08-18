
require 'xezat/packages'

class PackageManagerTest < Test::Unit::TestCase

  include Xezat

  def test_parsing
    variables = PackageManager.new(<<EOL)
INSTALLED.DB 2
gcc4 gcc4-4.5.3-3.tar.bz2 0
gcc4-core gcc4-core-4.5.3-3.tar.bz2 0
EOL
    assert_equal('gcc4-4.5.3-3', variables['gcc4'])
    assert_equal('gcc4-core-4.5.3-3', variables['gcc4-core'])
    assert_nil(variables['gcc4-gfortran'])
  end

end
