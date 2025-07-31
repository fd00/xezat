# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/font-util'

describe Xezat::Detector::FontUtil do
  it 'contains font-util' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('XORG_FONT_MACROS_VERSION')
    end
    detector = Xezat::Detector::FontUtil.new
    expect(detector.detect?(S: tmpdir)).to be_truthy
  end
  it 'contains no font-util' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::FontUtil.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
end
