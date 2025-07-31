# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/autoconf'

describe Xezat::Detector::Autoconf do
  it 'contains configure.ac' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'configure.ac')))
    topdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(topdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains configure.in' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'configure.in')))
    topdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(topdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no configure.{ac,in}' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'configure.xxx')))
    topdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(topdir, 'xezat.cygport')))
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
  it 'contains unused configure.{ac}' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'configure.ac')))
    topdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(topdir, 'xezat.cygport'))) do |f|
      f.puts('src_compile')
    end
    detector = Xezat::Detector::Autoconf.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
