# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/boost.m4'

describe Xezat::Detector::BoostM4 do
  it 'contains BOOST_REQUIRE' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('BOOST_REQUIRED')
    end
    detector = Xezat::Detector::BoostM4.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no BOOST_REQUIRE' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::BoostM4.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
