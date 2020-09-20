# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'xezat/config'

describe Xezat do
  include Xezat
  it 'has no config' do
    conf = config
    expect(conf['cygwin']['cygclassdir']).to eq '/usr/share/cygport/cygclass'
  end
  it 'has config' do
    tf = Tempfile.open do |t|
      t.puts 'cygwin:'
      t.puts '  cygclassdir: /tmp'
      t
    end
    conf = config(tf.path)
    expect(conf['cygwin']['cygclassdir']).to eq '/tmp'
  end
end
