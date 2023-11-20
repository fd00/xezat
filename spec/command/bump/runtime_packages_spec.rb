# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/runtime_package'

describe Xezat::Command::Bump do
  include Xezat

  it 'is runtime package' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_cygport_dep).and_return(<<LIST)
  cygwin-3-1
  foo-4-1
LIST
    actual = command.get_runtime_packages({}, nil, nil)
    expect(actual).to contain_exactly('cygwin-3-1', 'foo-4-1')
  end

  it 'contains libssl1.0-devel' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_cygport_dep).and_return(<<LIST)
  cygwin-3-1
  libssl-devel-1.1.1f-1
LIST
    actual = command.get_runtime_packages({ BUILD_REQUIRES: 'libssl1.0-devel' },
                                          { 'libssl1.0-devel': 'libssl1.0-devel-1.0.2t-1', 'libssl-devel': 'libssl-devel-1.1.1f-1' }, nil)
    expect(actual).to contain_exactly('cygwin-3-1')
  end

  it 'contains python3' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_cygport_dep).and_return(<<LIST)
  cygwin-3-1
  python3
LIST
    actual = command.get_runtime_packages({}, { python39: 'python39-3.9.16-1' }, nil)
    expect(actual).to contain_exactly('cygwin-3-1', 'python39-3.9.16-1')
  end

  it 'contains perl' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_cygport_dep).and_return(<<LIST)
  cygwin-3-1
  perl5_036
LIST
    actual = command.get_runtime_packages({}, { perl_base: 'perl-5.36.1-1' }, nil)
    expect(actual).to contain_exactly('cygwin-3-1', 'perl-5.36.1-1')
  end

  it 'contains ruby' do
    command = Xezat::Command::Bump.new(nil, nil)
    allow(command).to receive(:invoke_cygport_dep).and_return(<<LIST)
  cygwin-3-1
  ruby_32
LIST
    actual = command.get_runtime_packages({}, { ruby: 'ruby-3.2.2-2' }, nil)
    expect(actual).to contain_exactly('cygwin-3-1', 'ruby-3.2.2-2')
  end
end
