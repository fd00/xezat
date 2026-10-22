# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'xezat/command/bump'
require 'xezat/command/bump/compiler'

describe Xezat::Command::Bump do
  include Xezat

  # objdump --dwarf=info --dwarf-depth=1 of a DLL built from C and C++ sources
  # and linked with the Cygwin startup code
  objdump = <<~DUMP
    Contents of the .debug_info section:

      Compilation Unit @ offset 0:
       Length:        0x1d2 (32-bit)
       Version:       5
       Unit Type:     DW_UT_compile (1)
       Abbrev Offset: 0
       Pointer Size:  8
     <0><c>: Abbrev Number: 30 (DW_TAG_compile_unit)
        <d>   DW_AT_producer    : (indirect string, offset: 0x2a6): GNU C++17 14.4.0 -mtune=generic -march=x86-64 -ggdb -O2
        <11>   DW_AT_language    : 33	(C++14)
        <12>   DW_AT_name        : (indirect line string, offset: 0x0): /usr/src/debug/foo-1.0-1/src/foo.cpp
        <16>   DW_AT_comp_dir    : (indirect line string, offset: 0x2b): /usr/src/debug/foo-1.0-1/build/src
      Compilation Unit @ offset 0x1d6:
     <0><1e2>: Abbrev Number: 12 (DW_TAG_compile_unit)
        <1e3>   DW_AT_producer    : (indirect string, offset: 0x4f1): GNU C11 14.4.0 -mtune=generic -march=x86-64 -ggdb -O2
        <1e7>   DW_AT_language    : 29	(C11)
        <1e8>   DW_AT_name        : (indirect line string, offset: 0x51): ../src/bar.c
        <1ec>   DW_AT_comp_dir    : (indirect line string, offset: 0x5e): /usr/src/debug/foo-1.0-1/build
      Compilation Unit @ offset 0x3a0:
     <0><3ac>: Abbrev Number: 12 (DW_TAG_compile_unit)
        <3ad>   DW_AT_producer    : (indirect string, offset: 0x6a3): GNU C17 14.4.0 -mtune=generic -march=x86-64 -g -O2
        <3b1>   DW_AT_language    : 29	(C11)
        <3b2>   DW_AT_name        : (indirect line string, offset: 0x8c): /usr/src/debug/cygwin-3.6.11-1/winsup/cygwin/lib/premain0.c
        <3b6>   DW_AT_comp_dir    : (indirect line string, offset: 0xc8): /usr/src/debug/cygwin-3.6.11-1/x86_64-pc-cygwin/winsup/cygwin
      Compilation Unit @ offset 0x412:
     <0><41e>: Abbrev Number: 12 (DW_TAG_compile_unit)
        <41f>   DW_AT_producer    : (indirect string, offset: 0x6a3): GNU C++17 14.4.0 -mtune=generic -march=x86-64 -g -O2
        <423>   DW_AT_language    : 33	(C++14)
        <424>   DW_AT_name        : (indirect line string, offset: 0xf4): /usr/src/debug/cygwin-3.6.11-1/winsup/cygwin/lib/dll_main.cc
        <428>   DW_AT_comp_dir    : (indirect line string, offset: 0xc8): /usr/src/debug/cygwin-3.6.11-1/x86_64-pc-cygwin/winsup/cygwin
  DUMP

  def debuginfo_variables(dbgs)
    dir = Dir.mktmpdir
    dbgs.each do |dbg|
      path = File.join(dir, 'usr', 'lib', 'debug', 'usr', 'bin', dbg)
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.touch(path)
    end
    { D: dir, PF: 'foo-1.0-1' }
  end

  it 'contains c' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers(%i[C], nil)
    expect(actual).to include(:binutils, :'gcc-core')
  end

  it 'contains c++ without gcc-core' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers(%i[C++], nil)
    expect(actual).to contain_exactly(:binutils, :'gcc-g++')
  end

  it 'contains c from compiled files' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files(debuginfo_variables([]), [], { foo: ['/usr/bin/foo.exe'] })
    expect(actual).to contain_exactly(:binutils, :'gcc-core')
  end

  it 'contains fortran from runtimes' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files(debuginfo_variables([]), %w[libgfortran5], { foo: ['/usr/share/foo/foo.txt'] })
    expect(actual).to contain_exactly(:binutils, :'gcc-core', :'gcc-fortran')
  end

  it 'contains nothing from scripts' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files(debuginfo_variables([]), [], { foo: ['/usr/bin/foo', '/usr/share/foo/foo.py'] })
    expect(actual).to be_empty
  end

  it 'contains c and c++ from debuginfo, ignoring the startup code' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_objdump_dwarf).and_return(objdump)
    actual = command.get_languages_from_debuginfo(debuginfo_variables(%w[cygfoo-1.dll.dbg]))
    expect(actual).to contain_exactly(:C, :'C++')
  end

  it 'contains only c++ when only the startup code is c' do
    command = Xezat::Command::Bump.new(nil, nil)
    cpp_only = objdump.sub('../src/bar.c', '/usr/src/debug/cygwin-3.6.11-1/winsup/cygwin/lib/premain1.c')
    allow(command).to receive(:invoke_objdump_dwarf).and_return(cpp_only)
    actual = command.get_compilers_from_files(debuginfo_variables(%w[cygfoo-1.dll.dbg]), [], { foo: ['/usr/bin/cygfoo-1.dll'] })
    expect(actual).to contain_exactly(:binutils, :'gcc-g++')
  end

  it 'contains fortran from debuginfo' do
    command = Xezat::Command::Bump.new(nil, nil)
    fortran = objdump.sub('GNU C++17 14.4.0', 'GNU Fortran2008 14.4.0').sub("33\t(C++14)", "35\t(Fortran 08)")
    allow(command).to receive(:invoke_objdump_dwarf).and_return(fortran)
    actual = command.get_languages_from_debuginfo(debuginfo_variables(%w[cygfoo-1.dll.dbg]))
    expect(actual).to contain_exactly(:C, :Fortran)
  end
end
