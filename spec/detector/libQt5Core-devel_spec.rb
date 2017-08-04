require 'spec_helper'
require 'xezat/detector/libQt5Core-devel'

describe Xezat::Detector::LibQt5CoreDevel do
  it 'inherits qt5-qmake' do
    detector = Xezat::Detector::LibQt5CoreDevel.new
    expect(detector.detect({_qt5_qmake_CYGCLASS_: '1'})).to be_truthy
  end
  it 'does not inherit qt5-qmake' do
    detector = Xezat::Detector::LibQt5CoreDevel.new
    expect(detector.detect({})).to be_falsey
  end
end
