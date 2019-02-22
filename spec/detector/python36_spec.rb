# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python36'

describe Xezat::Detector::Python36 do
  it 'has lib' do
    tmpdir = Dir.mktmpdir
    FileUtils.mkpath(File.join(tmpdir, 'usr', 'lib', 'python3.6'))
    detector = Xezat::Detector::Python36.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
  it 'has executable script (python)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/env python')
    end
    detector = Xezat::Detector::Python36.new
    expect(detector.detect(D: tmpdir)).to be_falsy
  end
  it 'has executable script (python2)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/env python2')
    end
    detector = Xezat::Detector::Python36.new
    expect(detector.detect(D: tmpdir)).to be_falsey
  end
  it 'has executable script (python3)' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'xezat.py'))) do |f|
      f.puts('#!/usr/bin/env python3')
    end
    detector = Xezat::Detector::Python36.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
end
