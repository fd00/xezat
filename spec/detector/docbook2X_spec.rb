# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/docbook2X'

describe Xezat::Detector::Docbook2x do
  it 'contains docbook2x' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('docbook2x-man')
    end
    detector = Xezat::Detector::Docbook2x.new
    expect(detector.detect(S: tmpdir)).to be_truthy
  end
  it 'contains no docbook2x' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::Docbook2x.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
