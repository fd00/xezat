# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'xezat'
require 'xezat/cygchangelog'

describe Xezat::Cygchangelog do
  it 'has valid changelog' do
    str = <<~CL
      Port Notes:
      ----- version 2.0 -----
      Version bump.

      ----- version 1.0 -----
      Initial release.
    CL
    changelogs = Xezat::Cygchangelog.new(str)
    expect(changelogs[:'1.0']).to eq 'Initial release.'
    expect(changelogs[:'2.0']).to eq 'Version bump.'
  end
  it 'orders releases numerically' do
    changelogs = Xezat::Cygchangelog.new
    %w[0.6.2-1bl1 0.6.2-1bl10 0.6.2-1bl2 0.6.2-1bl9].each { |v| changelogs[v.intern] = v }
    expect(changelogs.each.map(&:first)).to eq %i[0.6.2-1bl10 0.6.2-1bl9 0.6.2-1bl2 0.6.2-1bl1]
  end
end
