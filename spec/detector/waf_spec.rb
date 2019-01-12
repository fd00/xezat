# frozen_string_literal: true

require 'spec_helper'
require 'xezat/detector/waf'

describe Xezat::Detector::Waf do
  it 'contains waf' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'waf')))
    detector = Xezat::Detector::Waf.new
    expect(detector.detect(S: tmpdir, _waf_CYGCLASS_: '1')).to be_falsey
  end
  it 'inherits waf' do
    tmpdir = Dir.mktmpdir
    detector = Xezat::Detector::Waf.new
    expect(detector.detect(S: tmpdir, _waf_CYGCLASS_: '1')).to be_truthy
  end
  it 'does not inherit waf' do
    tmpdir = Dir.mktmpdir
    detector = Xezat::Detector::Waf.new
    expect(detector.detect(S: tmpdir)).to be_falsey
  end
end
