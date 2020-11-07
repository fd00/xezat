# frozen_string_literal: true

require 'xezat/variables'

module Xezat
  module Command
    class Announce
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        variables = variables(@cygport)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'announce.erb'))
        print ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding).chop # remove redundant new line
      end
    end
  end
end
