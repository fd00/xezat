# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/autoconf'

describe Xezat::Detector::Autoconf do
  it 'contains configure.ac' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains configure.in' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.in')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no configure.{ac,in}' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.xxx')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
