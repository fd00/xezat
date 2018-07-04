# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/language'

describe Xezat::Command::Bump do
  include Xezat
  it 'contains fortran & cpp' do
    tmpdir = Dir.mktmpdir
    FileUtils.touch(File.expand_path(File.join(tmpdir, 'test.cpp')))
    File.atomic_write(File.expand_path(File.join(tmpdir, 'test.f90'))) do |f|
      f.write(<<FORTRAN)
        program hello
          print *, 'Hello World!'
        end program hello
FORTRAN
    end
    command = Xezat::Command::Bump.new(nil, nil)
    languages = command.get_languages(tmpdir)
    expect(languages).to contain_exactly('Fortran', 'C++')
  end
end
