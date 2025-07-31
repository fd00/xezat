# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/automake'

describe Xezat::Detector::Automake do
  it 'contains Makefile.am' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'Makefile.am')))
    topdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(topdir, 'xezat.cygport')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no Makefile.am' do
    srcdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(srcdir, 'Makefile.xxx')))
    topdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(topdir, 'xezat.cygport')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect?(top: topdir, S: srcdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
