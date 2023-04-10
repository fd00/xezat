# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/automake'

describe Xezat::Detector::Automake do
  it 'contains Makefile.am' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile.am')))
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no Makefile.am' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile.xxx')))
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
  it 'contains unused Makefile.am' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile.am')))
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.cygport'))) do |f|
      f.puts('src_compile')
    end
    detector = Xezat::Detector::Automake.new
    expect(detector.detect(S: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
