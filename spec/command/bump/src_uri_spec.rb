# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/src_uri'

describe Xezat::Command::Bump do
  include Xezat
  it 'is tarball' do
    cygclasses = Xezat::CygclassManager.new(File.expand_path(File.join(Xezat::ROOT_DIR, 'spec', 'cygport', 'cygclass')))
    command = Xezat::Command::Bump.new(nil, nil)
    src_uri = command.get_src_uri({ SRC_URI: 'https://example.com/ https://example.net/' }, cygclasses)
    expect(src_uri.size).to eq(2)
  end

  it 'is git' do
    cygclasses = Xezat::CygclassManager.new(File.expand_path(File.join(Xezat::ROOT_DIR, 'spec', 'cygport', 'cygclass')))
    command = Xezat::Command::Bump.new(nil, nil)
    src_uri = command.get_src_uri({ GIT_URI: 'https://github.com/fd00/xezat.git', _git_CYGCLASS_: 1 }, cygclasses)
    expect(src_uri.size).to eq(1)
  end
end
