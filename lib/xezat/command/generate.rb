# frozen_string_literal: true

require 'thor'

module Xezat
  module Command
    class Generate < Thor
      desc 'generate pkgconfig cygport', 'Generate *.pc'
      option :overwrite, type: :boolean, aliases: '-o', desc: 'overwrite *.pc'

      def pkgconfig(cygport)
        require 'xezat/generator/pkgconfig'
        Generator::Pkgconfig.new(options, cygport).generate
      end
    end
  end
end
