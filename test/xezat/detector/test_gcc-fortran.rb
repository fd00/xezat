
require 'xezat/detector/gcc-fortran'

class GccFortranTest < Test::Unit::TestCase

  include Xezat

  # ファイルの存在を検出できているか
  def test_get_components
    detector = GccFortran.new
    root_ok_f = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-fortran', 'ok_f'))}
    assert_equal(['gcc-fortran', 'gcc-core', 'binutils'], detector.get_components(root_ok_f))
    root_ok_f77 = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-fortran', 'ok_f77'))}
    assert_equal(['gcc-fortran', 'gcc-core', 'binutils'], detector.get_components(root_ok_f77))
    root_ok_f90 = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-fortran', 'ok_f90'))}
    assert_equal(['gcc-fortran', 'gcc-core', 'binutils'], detector.get_components(root_ok_f90))
    root_ok_f95 = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-fortran', 'ok_f95'))}
    assert_equal(['gcc-fortran', 'gcc-core', 'binutils'], detector.get_components(root_ok_f95))
    root_ng = {:S => File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-fortran', 'ng'))}
    assert_equal([], detector.get_components(root_ng))
  end

end
