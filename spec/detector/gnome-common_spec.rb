# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/gnome-common'

describe Xezat::Detector::GnomeCommon do
  it 'detects when :_gnome2_CYGCLASS_ key exists' do
    detector = Xezat::Detector::GnomeCommon.new
    expect(detector.detect?(_gnome2_CYGCLASS_: true)).to be_truthy
  end

  it 'does not detect when :_gnome2_CYGCLASS_ key is missing' do
    detector = Xezat::Detector::GnomeCommon.new
    expect(detector.detect?(foo: 'bar')).to be_falsey
  end
end
