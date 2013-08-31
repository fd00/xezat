
require 'xezat/tarball'

class TarballTest < Test::Unit::TestCase
  
  include Xezat
  
  def test_initialize
    tarball = Dir.chdir(File.dirname(__FILE__)) {
      Tarball.new(File.join('fixture', 'tarball', 'xezat-0.0.0-1.tar.bz2'))
    }
    assert_equal(202, tarball.size)
    assert_equal('1e2df784a4a483fba4f3c1a4c74fdadc', tarball.checksum)
  end
  
end
