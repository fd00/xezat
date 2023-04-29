# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/compiler'

describe Xezat::Command::Bump do
  include Xezat

  it 'contains c++' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers(%i[C++], nil)
    expect(actual).to include(:binutils, :'gcc-core', :'gcc-g++')
  end
end
