# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/detector/asciidoc'

describe Xezat::Detector::Asciidoc do
  it 'contains asciidoc' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'configure.ac'))) do |f|
      f.puts('asciidoc')
    end
    detector = Xezat::Detector::Asciidoc.new
    expect(detector.detect?(S: tmpdir)).to be_truthy
  end
  it 'contains no asciidoc' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'configure.ac')))
    detector = Xezat::Detector::Asciidoc.new
    expect(detector.detect?(S: tmpdir)).to be_falsey
  end
end
