# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'xezat/command/init'

describe Xezat::Command::Init do
  include Xezat
  it 'get cygport (not lib)' do
    command = Xezat::Command::Init.new(nil, nil)
    template = command.get_cygport({}, '', '', '', [], 'foo')
    expect(template).to(include('libfoo0'))
  end
  it 'get cygport (lib)' do
    command = Xezat::Command::Init.new(nil, nil)
    template = command.get_cygport({}, '', '', '', [], 'libfoo')
    expect(template).to(include('libfoo0'))
  end
end
