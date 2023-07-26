# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/gettext-devel'

describe Xezat::Detector::GettextDevel do
  it 'contains AM_GNU_GETTEXT' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('AM_GNU_GETTEXT')
    end
    detector = Xezat::Detector::GettextDevel.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no AM_GNU_GETTEXT' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::GettextDevel.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
