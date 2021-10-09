# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python37'

describe Xezat::Detector::Python37 do
  it 'has lib' do
    tmpdir = Dir.mktmpdir
    FileUtils.mkpath(File.join(tmpdir, 'usr', 'lib', 'python3.7'))
    detector = Xezat::Detector::Python37.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
  it 'has executable script (env python3.7)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/env python3.7')
    end
    detector = Xezat::Detector::Python37.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
  it 'has executable script (python3.7)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/python3.7')
    end
    detector = Xezat::Detector::Python37.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
  it 'has executable script (python3)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/python3')
    end
    detector = Xezat::Detector::Python37.new
    expect(detector.detect(D: tmpdir)).to be_falsey
  end
end
