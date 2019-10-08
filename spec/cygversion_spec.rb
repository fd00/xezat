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
end
