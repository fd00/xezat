# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/make'

describe Xezat::Detector::Make do
  it 'contains Makefile' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile')))
    detector = Xezat::Detector::Make.new
    expect(detector.detect(B: tmpdir)).to be_truthy
  end
  it 'contains makefile' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'makefile')))
    detector = Xezat::Detector::Make.new
    expect(detector.detect(B: tmpdir)).to be_truthy
  end
  it 'contains cygmake' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.cygport'))) do |f|
      f.puts('cygmake')
    end
    detector = Xezat::Detector::Make.new
    expect(detector.detect(B: tmpdir, top: tmpdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no makefile' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Make.new
    expect(detector.detect(B: tmpdir, top: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
