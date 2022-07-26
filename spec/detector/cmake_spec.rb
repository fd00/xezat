# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/cmake'

describe Xezat::Detector::Cmake do
  it 'inherits cmake' do
    detector = Xezat::Detector::Cmake.new
    expect(detector.detect(_cmake_CYGCLASS_: '1')).to be_truthy
  end
  it 'does not inherit cmake' do
    detector = Xezat::Detector::Cmake.new
    expect(detector.detect({})).to be_falsey
  end
end
