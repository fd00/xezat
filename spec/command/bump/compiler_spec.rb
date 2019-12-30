# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/compiler'

describe Xezat::Command::Bump do
  include Xezat

  it 'contains c++ and ruby' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers(%w[C++ Ruby], nil)
    expect(actual).to include(:binutils, :'gcc-core', :'gcc-g++', :ruby)
  end
end
