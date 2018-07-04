# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/file'

describe Xezat::Command::Bump do
  include Xezat

  it 'is file' do
    tmpdir = Dir.mktmpdir
    variables = { PN: :foo, pkg_name: %i[foo libfoo0], T: tmpdir }
    File.atomic_write(File.expand_path(File.join(tmpdir, '.foo.lst'))) do |f|
      f.puts('usr/bin/foo.exe')
      f.puts('usr/lib/')
    end
    File.atomic_write(File.expand_path(File.join(tmpdir, '.libfoo0.lst'))) do |f|
      f.puts('usr/bin/cygfoo-0.dll')
    end
    command = Xezat::Command::Bump.new(nil, nil)
    actual = command.get_files(variables)
    expect(actual).to include(foo: ['/usr/bin/foo.exe', '/usr/share/doc/Cygwin/foo.README'], libfoo0: ['/usr/bin/cygfoo-0.dll'])
  end
end
