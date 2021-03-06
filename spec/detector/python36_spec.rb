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
end
