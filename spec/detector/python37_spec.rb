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
end
