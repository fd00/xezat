# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python39-docutils'

describe Xezat::Detector::Python39Docutils do
  it 'contains rst2man in configure.ac' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AC_CHECK_PROG([RST2MAN], [rst2man])')
    end
    detector = Xezat::Detector::Python39Docutils.new
    expect(detector.detect?(S: tmpdir)).to be_truthy
  end
  it 'contains no rst2man in configure.ac' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::Python39Docutils.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
  it 'contains rst2man in meson.build' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'meson.build'))) do |f|
      f.puts("find_program('rst2man', required: with_man_pages == 'true')")
    end
    detector = Xezat::Detector::Python39Docutils.new
    expect(detector.detect?(S: tmpdir, _meson_CYGCLASS_: true)).to be_truthy
  end
  it 'contains no rst2man in meson.build' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'meson.build')))
    detector = Xezat::Detector::Python39Docutils.new
    expect(detector.detect?(S: tmpdir, _meson_CYGCLASS_: true)).to be_falsey
  end
end
