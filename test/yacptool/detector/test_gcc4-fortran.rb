
require 'yacptool/detector/gcc4-fortran'

class Gcc4FortranTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Gcc4Fortran.new
    root_ok_f = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-fortran', 'ok_f'))
    assert_equal(['gcc4-fortran', 'gcc4-core', 'binutils'], detector.get_components(root_ok_f))
    root_ok_f77 = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-fortran', 'ok_f77'))
    assert_equal(['gcc4-fortran', 'gcc4-core', 'binutils'], detector.get_components(root_ok_f77))
    root_ok_f90 = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-fortran', 'ok_f90'))
    assert_equal(['gcc4-fortran', 'gcc4-core', 'binutils'], detector.get_components(root_ok_f90))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-fortran', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
