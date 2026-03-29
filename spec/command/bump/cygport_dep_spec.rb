# frozen_string_literal: true

require 'spec_helper'
require 'xezat/command/bump'
require 'xezat/command/bump/cygport_dep'

describe Xezat::Command::Bump do
  include Xezat

  let(:command) { Xezat::Command::Bump.new(nil, nil) }
  let(:variables) { { D: '/tmp/test_install' } }
  let(:cygport_file) { '/path/to/package.cygport' }

  describe '#invoke_cygport_dep' do
    context 'when successful' do
      it 'builds PATH with exe and dll directories' do
        allow(Find).to receive(:find).with('/tmp/test_install').and_return(
          %w[
            /tmp/test_install/usr/bin/foo.exe
            /tmp/test_install/usr/lib/bar.dll
            /tmp/test_install/usr/share/doc/readme.txt
          ]
        )

        expected_path = '/tmp/test_install/usr/bin:/tmp/test_install/usr/lib'
        expect(Open3).to receive(:capture3).with(
          { 'PATH' => "#{expected_path}:#{ENV.fetch('PATH')}" },
          "bash #{File.expand_path(File.join(Xezat::DATA_DIR, 'cygport.sh'))} #{cygport_file} dep"
        ).and_return(['dependency output', '', double(success?: true)])

        result = command.invoke_cygport_dep(variables, cygport_file)
        expect(result).to eq('dependency output')
      end

      it 'includes .so files in PATH' do
        allow(Find).to receive(:find).with('/tmp/test_install').and_return(
          %w[
            /tmp/test_install/usr/lib/plugin.so
          ]
        )

        expected_path = '/tmp/test_install/usr/lib'
        expect(Open3).to receive(:capture3).with(
          { 'PATH' => "#{expected_path}:#{ENV.fetch('PATH')}" },
          "bash #{File.expand_path(File.join(Xezat::DATA_DIR, 'cygport.sh'))} #{cygport_file} dep"
        ).and_return(['result', '', double(success?: true)])

        result = command.invoke_cygport_dep(variables, cygport_file)
        expect(result).to eq('result')
      end

      it 'removes duplicate directories from PATH' do
        allow(Find).to receive(:find).with('/tmp/test_install').and_return(
          %w[
            /tmp/test_install/usr/bin/foo.exe
            /tmp/test_install/usr/bin/bar.exe
            /tmp/test_install/usr/lib/baz.dll
          ]
        )

        expected_path = '/tmp/test_install/usr/bin:/tmp/test_install/usr/lib'
        expect(Open3).to receive(:capture3).with(
          { 'PATH' => "#{expected_path}:#{ENV.fetch('PATH')}" },
          anything
        ).and_return(['output', '', double(success?: true)])

        command.invoke_cygport_dep(variables, cygport_file)
      end

      it 'warns when stderr is not empty but command succeeds' do
        allow(Find).to receive(:find).and_return([])
        allow(Open3).to receive(:capture3).and_return(['output', 'warning message', double(success?: true)])

        expect(Xezat.logger).to receive(:warn).with('    Stderr = warning message')

        command.invoke_cygport_dep(variables, cygport_file)
      end
    end

    context 'when failed' do
      it 'raises CygportProcessError on command failure' do
        allow(Find).to receive(:find).and_return([])
        allow(Open3).to receive(:capture3).and_return(['', 'error message', double(success?: false)])

        expect do
          command.invoke_cygport_dep(variables, cygport_file)
        end.to raise_error(Xezat::CygportProcessError, 'error message')
      end
    end
  end
end
