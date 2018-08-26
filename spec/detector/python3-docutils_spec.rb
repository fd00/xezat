# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python3-docutils'

describe Xezat::Detector::Python3Docutils do
  it 'contains rst2man' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AC_CHECK_PROG([RST2MAN], [rst2man])')
    end
    detector = Xezat::Detector::Python3Docutils.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no rst2man' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::Python3Docutils.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
