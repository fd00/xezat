# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/command/validate'

describe Xezat::Command::Validate do
  include Xezat

  it 'contains valid char only' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    cygport = File.expand_path(File.join(tmpdir, 'foo.cygport'))
    File.atomic_write(cygport) do |f|
      f.puts('NAME=foo')
    end
    Xezat.logger = spy
    command.validate_cygport(cygport)
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains invalid char (BOM)' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    cygport = File.expand_path(File.join(tmpdir, 'foo.cygport'))
    File.atomic_write(cygport) do |f|
      f.puts("\xEF\xBB\xBFNAME=foo")
    end
    Xezat.logger = spy
    command.validate_cygport(cygport)
    expect(Xezat.logger).to have_received(:error).exactly(1).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains valid category' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_category('Text')
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains invalid category' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_category('Emulators')
    expect(Xezat.logger).to have_received(:error).exactly(1).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains multiple valid categories' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_category('Devel Text')
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains a mix of valid and invalid categories' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_category('Devel Emulators')
    expect(Xezat.logger).to have_received(:error).with('    Category is invalid : Emulators').exactly(1).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'contains multiple valid categories separated by newlines' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_category("Devel\nText")
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end
end
