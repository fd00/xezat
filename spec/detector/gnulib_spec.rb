# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/gnulib'

describe Xezat::Detector::Gnulib do
  it 'contains gnulib-tools' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.cygport'))) do |f|
      f.puts('gnulib-tools')
    end
    detector = Xezat::Detector::Gnulib.new
    expect(detector.detect(top: tmpdir, cygportfile: 'xezat.cygport')).to be_truthy
  end
  it 'contains no gnulib-tools' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'xezat.cygport')))
    detector = Xezat::Detector::Gnulib.new
    expect(detector.detect(top: tmpdir, cygportfile: 'xezat.cygport')).to be_falsey
  end
end
