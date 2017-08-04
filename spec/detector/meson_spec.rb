require 'spec_helper'
require 'xezat/detector/meson'

describe Xezat::Detector::Meson do
  it 'inherits meson' do
    detector = Xezat::Detector::Meson.new
    expect(detector.detect({_meson_CYGCLASS_: '1'})).to be_truthy
  end
  it 'does not inherit meson' do
    detector = Xezat::Detector::Meson.new
    expect(detector.detect({})).to be_falsey
  end
end
