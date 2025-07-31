# frozen_string_literal: true

require 'securerandom'
require 'spec_helper'
require 'tempfile'
require 'xezat/packages'

describe Xezat do
  include Xezat

  it 'has no such database' do
    expect { packages(SecureRandom.hex(8)) }.to raise_error(ArgumentError)
  end
  it 'has invalid & valid record' do
    tf = Tempfile.open do |t|
      t.puts 'foo foo-1.0-1bl1.tar.bz2 0'
      t.puts 'bar bar-2.0-1bl1.tar.bz2' # an invalid record is ignored
      t.puts 'baz baz-3.0-1bl1.tar.bz2 0'
      t
    end
    pkgs = packages(tf.path)
    expect(pkgs[:foo]).to eq 'foo-1.0-1bl1'
    expect(pkgs[:bar]).to be_nil
    expect(pkgs[:baz]).to eq 'baz-3.0-1bl1'
  end
end
