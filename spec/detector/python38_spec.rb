# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/python38'

describe Xezat::Detector::Python38 do
  it 'has lib' do
    tmpdir = Dir.mktmpdir
    FileUtils.mkpath(File.join(tmpdir, 'usr', 'lib', 'python3.8'))
    detector = Xezat::Detector::Python38.new
    expect(detector.detect(D: tmpdir)).to be_truthy
  end
end
