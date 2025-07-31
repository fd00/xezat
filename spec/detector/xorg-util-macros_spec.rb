# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/xorg-util-macros'

describe Xezat::Detector::XorgUtilMacros do
  it 'contains xorg-util-macros' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('XORG_MACROS_VERSION')
    end
    detector = Xezat::Detector::XorgUtilMacros.new
    expect(detector.detect?(S: tmpdir)).to be_truthy
  end
  it 'contains no xorg-util-macros' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::XorgUtilMacros.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
end
