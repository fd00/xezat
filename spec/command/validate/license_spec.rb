# frozen_string_literal: true

require 'fileutils'
require 'securerandom'
require 'tmpdir'
require 'xezat/command/validate/license'

describe Xezat::Command::Validate do
  include Xezat

  it 'has no license' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_license({})
    expect(Xezat.logger).to have_received(:warn).exactly(2).times
    Xezat.logger = Logger.new('/dev/null')
  end

  it 'has valid license' do
    command = Xezat::Command::Validate.new(nil, nil)
    tmpdir = Dir.mktmpdir
    license_uri = SecureRandom.hex(8)
    FileUtils.touch(File.join(tmpdir, license_uri))
    Xezat.logger = spy
    command.validate_license({ LICENSE: 'MIT', S: tmpdir, LICENSE_URI: license_uri })
    expect(Xezat.logger).to have_received(:debug).exactly(2).times
    Xezat.logger = Logger.new('/dev/null')
  end

  it 'has invalid license & uri not found' do
    command = Xezat::Command::Validate.new(nil, nil)
    Xezat.logger = spy
    command.validate_license({ LICENSE: SecureRandom.hex(8), S: SecureRandom.hex(8), LICENSE_URI: SecureRandom.hex(8) })
    expect(Xezat.logger).to have_received(:error).exactly(2).times
    Xezat.logger = Logger.new('/dev/null')
  end
end
