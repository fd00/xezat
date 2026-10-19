# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'xezat/variables'

describe Xezat do
  include Xezat

  it 'rewraps DESCRIPTION within 80 columns' do
    Dir.mktmpdir do |tmpdir|
      cygport = File.join(tmpdir, 'foo-1.0-1.cygport')
      FileUtils.touch(cygport)
      description = "C++ library for the efficient computation of scattering form factors (Fourier shape transforms)\n  of arbitrary polyhedra"
      allow(self).to receive(:bashvar).and_return({ DESCRIPTION: description })
      expect(variables(cygport)[:DESCRIPTION]).to eq <<~DESC
        C++ library for the efficient computation of scattering form factors (Fourier
        shape transforms) of arbitrary polyhedra
      DESC
    end
  end
end
