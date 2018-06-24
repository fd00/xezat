# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/libtool'

describe Xezat::Detector::Libtool do
  it 'contains ltmain.sh' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'ltmain.sh')))
    detector = Xezat::Detector::Libtool.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no ltmain.sh' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'ltmain.xxx')))
    detector = Xezat::Detector::Libtool.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
