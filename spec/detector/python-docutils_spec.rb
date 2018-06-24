# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python-docutils'

describe Xezat::Detector::PythonDocutils do
  it 'contains rst2man' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AC_CHECK_PROG(RST2MAN, rst2man, yes, no)')
    end
    detector = Xezat::Detector::PythonDocutils.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains configure.ac' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::PythonDocutils.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
