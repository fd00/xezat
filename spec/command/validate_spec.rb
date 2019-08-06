# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'securerandom'
require 'spec_helper'
require 'xezat/command/validate'

describe Xezat::Command::Validate do
  include Xezat

  it 'has no pc' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    vars = {
      D: tmpdir,
      PN: SecureRandom.hex(8),
      PV: '1.6.37'
    }
    Xezat.logger = spy
    command.validate_pkgconfig(vars)
    expect(Xezat.logger).to have_received(:debug).exactly(0).times
    Xezat.logger = Logger.new('/dev/null')
  end

  it 'has pc' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    pkgconfigdir = File.join(tmpdir, 'usr', 'lib', 'pkgconfig')
    vars = {
      D: tmpdir,
      PN: SecureRandom.hex(8),
      PV: [SecureRandom.random_number(100)]
    }
    FileUtils.mkpath(pkgconfigdir)
    File.atomic_write(File.expand_path(File.join(pkgconfigdir, "#{vars[:PN]}.pc"))) do |f|
      f.write(<<PC)
        prefix=/usr/local/Cellar/libpng/1.6.37
        exec_prefix=${prefix}
        libdir=${exec_prefix}/lib
        includedir=${prefix}/include/libpng16

        Name: libpng
        Description: Loads and saves PNG files
        Version: #{vars[:PV]}
        Requires: zlib
        Libs: -L${libdir} -lpng16
        Libs.private: -lz
        Cflags: -I${includedir}
PC
    end
    Xezat.logger = spy
    command.validate_pkgconfig(vars)
    expect(Xezat.logger).to have_received(:debug).twice
    Xezat.logger = Logger.new('/dev/null')
  end

  it 'has pc and version differs' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    pkgconfigdir = File.join(tmpdir, 'usr', 'lib', 'pkgconfig')
    vars = {
      D: tmpdir,
      PN: SecureRandom.hex(8),
      PV: [SecureRandom.random_number(100)]
    }
    FileUtils.mkpath(pkgconfigdir)
    File.atomic_write(File.expand_path(File.join(pkgconfigdir, "#{vars[:PN]}.pc"))) do |f|
      f.write(<<PC)
        prefix=/usr/local/Cellar/libpng/1.6.37
        exec_prefix=${prefix}
        libdir=${exec_prefix}/lib
        includedir=${prefix}/include/libpng16

        Name: libpng
        Description: Loads and saves PNG files
        Version: 9999
        Requires: zlib
        Libs: -L${libdir} -lpng16
        Libs.private: -lz
        Cflags: -I${includedir}
PC
    end
    Xezat.logger = spy
    command.validate_pkgconfig(vars)
    expect(Xezat.logger).to have_received(:debug).twice
    expect(Xezat.logger).to have_received(:error).once
    Xezat.logger = Logger.new('/dev/null')
  end
end
