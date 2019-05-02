# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/libQt5Core-devel'

describe Xezat::Detector::Libqt5coreDevel do
  it 'inherits qt5-qmake' do
    detector = Xezat::Detector::Libqt5coreDevel.new
    expect(detector.detect(_qt5_qmake_CYGCLASS_: '1')).to be_truthy
  end
  it 'does not inherit qt5-qmake' do
    detector = Xezat::Detector::Libqt5coreDevel.new
    expect(detector.detect({})).to be_falsey
  end
end
