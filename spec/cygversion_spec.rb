# frozen_string_literal: true

require 'spec_helper'
require 'xezat'
require 'xezat/cygversion'

describe Xezat::Cygversion do
  it 'has valid version' do
    cygversion = Xezat::Cygversion.new('1.2.3-4').to_a
    expect(cygversion[0]).to eq '1.2.3'
    expect(cygversion[2]).to eq '4'
  end
  it 'has valid version & revision' do
    cygversion = Xezat::Cygversion.new('1.2.3+git20191001-4').to_a
    expect(cygversion[0]).to eq '1.2.3'
    expect(cygversion[1]).to eq 20_191_001
    expect(cygversion[2]).to eq '4'
  end
  it 'compares releases numerically' do
    expect(Xezat::Cygversion.new('0.6.2-1bl10') <=> Xezat::Cygversion.new('0.6.2-1bl9')).to eq 1
    expect(Xezat::Cygversion.new('0.6.2-1bl2') <=> Xezat::Cygversion.new('0.6.2-1bl10')).to eq(-1)
    expect(Xezat::Cygversion.new('0.6.2-10') <=> Xezat::Cygversion.new('0.6.2-9')).to eq 1
  end
  it 'puts a snapshot after its base version' do
    expect(Xezat::Cygversion.new('1.11+svn58-1bl1') <=> Xezat::Cygversion.new('1.11-1bl1')).to eq 1
    expect(Xezat::Cygversion.new('1.0+git20251223-1bl1') <=> Xezat::Cygversion.new('1.0-1bl1')).to eq 1
    expect(Xezat::Cygversion.new('1.14-1bl1') <=> Xezat::Cygversion.new('1.11+svn58-1bl1')).to eq 1
  end
end
