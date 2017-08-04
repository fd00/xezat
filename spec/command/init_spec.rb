require 'spec_helper'
require 'tempfile'
require 'xezat/command/init'

describe Xezat::Command::Init do
  include Xezat
  it 'get cygport (not lib)' do
    command = Xezat::Command::Init.new(nil, nil)
    template = command.get_cygport({}, '','','', [], 'foo')
    pkg_names =<<EOS
PKG_NAMES="
	foo
	libfoo0
	libfoo-devel
"
EOS
    expect(template).to(include(pkg_names))
  end
  it 'get cygport (lib)' do
    command = Xezat::Command::Init.new(nil, nil)
    template = command.get_cygport({}, '','','', [], 'libfoo')
    pkg_names =<<EOS
PKG_NAMES="
	libfoo
	libfoo0
	libfoo-devel
"
EOS
    expect(template).to(include(pkg_names))
  end
end
