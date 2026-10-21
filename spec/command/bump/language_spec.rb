# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/language'

describe Xezat::Command::Bump do
  include Xezat

  it 'contains C++' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'test.cpp')))
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to contain_exactly(:'C++')
  end

  it 'contains Fortran77' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'test.f77'))) do |f|
      f.write(<<~FORTRAN77)
        PROGRAM HELLO
        PRINT *, 'HELLO, WORLD!'
        END PROGRAM HELLO
      FORTRAN77
    end
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to contain_exactly(:Fortran)
  end

  it 'contains Fortran90' do
    tmpdir = Dir.mktmpdir
    File.atomic_write(File.expand_path(File.join(tmpdir, 'test.f90'))) do |f|
      f.write(<<FORTRAN)
        program hello
          print *, 'Hello World!'
        end program hello
FORTRAN
    end
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to contain_exactly(:'Fortran Free Form')
  end

  it 'contains Lex' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'test.l')))
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to contain_exactly(:Lex)
  end

  it 'ignores unknown extensions' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'test.proto')))
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to be_empty
  end
end
