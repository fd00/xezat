require 'securerandom'
require 'spec_helper'
require 'xezat'
require 'xezat/cygclasses'

describe Xezat::CygclassManager do
  it 'is not cygclass dir' do
    expect { Xezat::CygclassManager.new(SecureRandom.hex(8)) }.to raise_error(ArgumentError)
  end
  it 'has cygclasses' do
    cygclasses = Xezat::CygclassManager.new(File.expand_path(File.join(Xezat::ROOT_DIR, 'spec', 'cygport', 'cygclass')))
    expect(cygclasses.include? (:autotools)).to be_truthy
    expect(cygclasses.include? (:git)).to be_truthy
    expect(cygclasses.include? (:nosuchclass)).to be_falsey
    expect(cygclasses.vcs?(:autotools)).to be_falsey
    expect(cygclasses.vcs?(:git)).to be_truthy
    expect(cygclasses.vcs?(:nosuchclass)).to be_falsey
  end
end
