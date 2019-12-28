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
  libfoo-4-1
LIST
    actual = command.get_runtime_packages(nil, nil)
    expect(actual).to contain_exactly('cygwin-3-1', 'libfoo-4-1')
  end
end
