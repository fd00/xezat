# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/autoconf-archive'

describe Xezat::Detector::AutoconfArchive do
  it 'contains autoconf-archive macro in configure.ac' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AX_COMPILER_FLAGS')
    end
    detector = Xezat::Detector::AutoconfArchive.new
    expect(detector.detect?(S: tmpdir)).to be_truthy
  end
  it 'contains not autoconf-archive macro in configure.ac' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AX_CPP_VARARG_MACRO_ISO')
    end
    detector = Xezat::Detector::AutoconfArchive.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
  it 'contains no autoconf-archive macro in configure.ac' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AC_INIT(')
    end
    detector = Xezat::Detector::AutoconfArchive.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
end
