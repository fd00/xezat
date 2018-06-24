# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/automake'

describe Xezat::Detector::Automake do
  it 'contains Makefile.am' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile.am')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no Makefile.am' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'Makefile.xxx')))
    detector = Xezat::Detector::Automake.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
