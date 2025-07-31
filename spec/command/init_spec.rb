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
  it 'get repository variables' do
    command = Xezat::Command::Init.new(nil, nil)
    variables = command.get_repository_variables('github')
    expect(variables[:HOMEPAGE]).not_to(be_empty)
  end
  it 'get no repository variables' do
    command = Xezat::Command::Init.new(nil, nil)
    variables = command.get_repository_variables(nil)
    expect(variables[:HOMEPAGE]).to(be_empty)
  end
end
