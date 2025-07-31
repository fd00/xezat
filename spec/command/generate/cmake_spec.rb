# frozen_string_literal: true

require 'securerandom'
require 'xezat/generator/cmake'

describe Xezat::Generator::CMake do
  include Xezat

  it 'generates CMakeLists.txt' do
    command = Xezat::Generator::CMake.new(nil, nil)
    tmpdir = Dir.mktmpdir
    vars = {
      S: tmpdir,
      PN: SecureRandom.hex(8),
      PV: '1.2.3',
      SUMMARY: SecureRandom.alphanumeric(64),
      HOMEPAGE: 'https://example.com/'
    }
    command.generate_cmakelists(vars, {})
    expect(File).to exist("#{tmpdir}/CMakeLists.txt")
  end
end
