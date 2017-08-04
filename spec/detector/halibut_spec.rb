require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/halibut'

describe Xezat::Detector::Halibut do
  it 'contains *.but' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'foo.but')))
    detector = Xezat::Detector::Halibut.new
    expect(detector.detect({S: tmpdir})).to be_truthy
  end
  it 'contains no *.but' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'foo.xxx')))
    detector = Xezat::Detector::Halibut.new
    expect(detector.detect({S: tmpdir})).to be_falsey
  end
end
