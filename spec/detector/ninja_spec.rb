# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/ninja'

describe Xezat::Detector::Ninja do
  it 'contains build.ninja' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'build.ninja')))
    detector = Xezat::Detector::Ninja.new
    expect(detector.detect(B: tmpdir)).to be_truthy
  end
end
