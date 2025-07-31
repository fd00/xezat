# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/nasm'

describe Xezat::Detector::Nasm do
  it 'inherits meson and needs nasm' do
    detector = Xezat::Detector::Nasm.new
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'meson.build'))) do |f|
      f.puts("find_program('nasm')")
    end
    expect(detector.detect?(_meson_CYGCLASS_: '1', S: tmpdir)).to be_truthy
  end
end
