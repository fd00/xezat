# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/compiler'

describe Xezat::Command::Bump do
  include Xezat

  it 'contains c' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers(%i[C], nil)
    expect(actual).to include(:binutils, :'gcc-core')
  end

  it 'contains c from compiled files' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files([], { foo: ['/usr/bin/foo.exe'] })
    expect(actual).to contain_exactly(:binutils, :'gcc-core')
  end

  it 'contains fortran from runtimes' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files(%w[libgfortran5], { foo: ['/usr/share/foo/foo.txt'] })
    expect(actual).to contain_exactly(:binutils, :'gcc-core', :'gcc-fortran')
  end

  it 'contains nothing from scripts' do
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_compilers_from_files([], { foo: ['/usr/bin/foo', '/usr/share/foo/foo.py'] })
    expect(actual).to be_empty
  end
end
