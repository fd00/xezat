# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'fileutils'
require 'spec_helper'
require 'tmpdir'
require 'xezat/command/validate/appstream'

describe Xezat::Command::Validate do
  include Xezat

  it 'has no appdata directory' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    vars = { D: tmpdir }
    Xezat.logger = spy
    command.validate_appstream_path(vars)
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'has no file in the appdata directory' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    appdatadir = File.join(tmpdir, 'usr', 'share', 'appdata')
    FileUtils.mkpath(appdatadir)
    vars = { D: tmpdir }
    Xezat.logger = spy
    command.validate_appstream_path(vars)
    expect(Xezat.logger).to have_received(:error).exactly(0).times
    Xezat.logger = Logger.new(File::NULL)
  end

  it 'has a file in the legacy appdata directory' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    appdatadir = File.join(tmpdir, 'usr', 'share', 'appdata')
    FileUtils.mkpath(appdatadir)
    File.atomic_write(File.join(appdatadir, 'foo.appdata.xml')) do |f|
      f.write('<component/>')
    end
    vars = { D: tmpdir }
    Xezat.logger = spy
    command.validate_appstream_path(vars)
    expect(Xezat.logger).to have_received(:error)
      .with('    foo.appdata.xml is in the legacy AppStream path /usr/share/appdata, move it to /usr/share/metainfo')
      .exactly(1).times
    Xezat.logger = Logger.new(File::NULL)
  end
end
