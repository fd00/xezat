
require 'yacptool/detector/gcc-g++'

class GccGppTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = GccGpp.new
    root_ok_cc = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_cc'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_cc))
    root_ok_C = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_C'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_C))
    root_ok_cpp = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_cpp'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_cpp))
    root_ok_cxx = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_cxx'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_cxx))
    root_ok_hh = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_hh'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_hh))
    root_ok_H = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_H'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_H))
    root_ok_hpp = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_hpp'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_hpp))
    root_ok_hxx = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ok_hxx'))
    assert_equal(['gcc-g++', 'gcc-core', 'binutils'], detector.get_components(root_ok_hxx))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc-g++', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
