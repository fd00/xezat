# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/waf'

describe Xezat::Detector::Waf do
  it 'inherits waf' do
    detector = Xezat::Detector::Waf.new
    expect(detector.detect(_waf_CYGCLASS_: '1')).to be_truthy
  end
  it 'does not inherit waf' do
    detector = Xezat::Detector::Waf.new
    expect(detector.detect({})).to be_falsey
  end
end
