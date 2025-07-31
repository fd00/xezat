# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/gobject-introspection'

describe Xezat::Detector::GobjectIntrospection do
  it 'has girepository_dir' do
    tmpdir = Dir.mktmpdir
    FileUtils.mkpath(File.join(tmpdir, 'usr', 'lib', 'girepository-1.0'))
    detector = Xezat::Detector::GobjectIntrospection.new
    expect(detector.detect?(D: tmpdir)).to be_truthy
  end
  it 'has no girepository_dir' do
    tmpdir = Dir.mktmpdir
    detector = Xezat::Detector::GobjectIntrospection.new
    expect(detector.detect?(D: tmpdir)).to be_falsey
  end
end
