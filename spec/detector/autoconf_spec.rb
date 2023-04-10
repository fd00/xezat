# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/autoconf'

describe Xezat::Detector::Autoconf do
  it 'contains configure.ac' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains configure.in' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.in')))
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no configure.{ac,in}' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.xxx')))
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
  it 'contains unused configure.{ac}' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.cygport'))) do |f|
      f.puts('src_compile')
    end
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
