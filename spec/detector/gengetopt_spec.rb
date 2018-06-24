# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/gengetopt'

describe Xezat::Detector::Gengetopt do
  it 'contains *.ggo' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'foo.ggo')))
    detector = Xezat::Detector::Gengetopt.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no *.ggo' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'foo.xxx')))
    detector = Xezat::Detector::Gengetopt.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
