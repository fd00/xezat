
require 'yacptool/detector/gcc4-g++'

class Gcc4GppTest < Test::Unit::TestCase

  include Yacptool

  # ファイルの存在を検出できているか
  def test_get_components
    detector = Gcc4Gpp.new
    root_ok_cc = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_cc'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_cc))
    root_ok_C = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_C'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_C))
    root_ok_cpp = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_cpp'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_cpp))
    root_ok_cxx = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_cxx'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_cxx))
    root_ok_hh = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_hh'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_hh))
    root_ok_H = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_H'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_H))
    root_ok_hpp = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_hpp'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_hpp))
    root_ok_hxx = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ok_hxx'))
    assert_equal(['gcc4-g++', 'gcc4-core', 'binutils'], detector.get_components(root_ok_hxx))
    root_ng = File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'gcc4-g++', 'ng'))
    assert_equal([], detector.get_components(root_ng))
  end

end
