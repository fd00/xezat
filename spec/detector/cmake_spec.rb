# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/cmake'

describe Xezat::Detector::Cmake do
  it 'contains CMakeLists.txt' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'CMakeLists.txt')))
    detector = Xezat::Detector::Cmake.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no CMakeLists.txt' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'CMakeLists.xxx')))
    detector = Xezat::Detector::Cmake.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
